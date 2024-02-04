#!/bin/bash

## repo-update ::
# Copy files listed in $files_src from $dir_src to script directory. If $keep_all
# is false, delete all files in script directory except the script itself,
# .git/, and the files listed in $files_keep. If $git_push is true, commit and
# push git repo in script directory to remote.

## config ::
git_push=false
keep_all=true
dir_src=''
files_keep=()
files_src=()

## internal ::
dir_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
errors=()
file_script="$(basename "$0")"
files=()
find_args=()

## main ::
while (($#)); do case "$1" in
    -K|--keep)  keep_all=true ;;
    -P|--push)  git_push=true ;;
    *)          errors+=("E: unknown option: $1") ;;
esac; shift; done

# check for errors:
if [ ! -d "$dir_src" ]; then
    errors+=("E: source directory not found: $dir_src")
fi
if [ "$git_push" = 'true' ]; then
    if ! command -v git &>/dev/null; then
        errors+=('E: git not found')
    fi
    if [ "$(git -C "$dir_script" rev-parse --git-dir 2>/dev/null)" != '.git' ]; then
        errors+=("E: not root of a git repo: $dir_script")
    fi
fi
if [ "${#errors[@]}" -gt 0 ]; then
    # print errors and exit:
    printf '%s\n' "${errors[@]}" >&2
    exit "${#errors[@]}"
fi

if [ "$keep_all" = 'false' ]; then
    # delete everything in $dir_script that isn't in $files_keep:
    find_args=("$dir_script" -maxdepth 1 -not '(' -wholename "$dir_script" -or
      -wholename "$dir_script/$file_script" -or -wholename "$dir_script/.git")
    for file in "${files_keep[@]}"; do
        find_args+=(-or -wholename "$dir_script/$file")
    done
    find_args+=(')' -exec rm -r '{}' '+')
    find "${find_args[@]}"
fi

# copy files in $files_src (preserving paths) from $dir_src to $dir_script:
cd "$dir_src"
for file in "${files_src[@]}"; do
    [ -e "$file" ] && files+=("$file")
done
cp -r --parents "${files[@]}" "$dir_script"

# push to remote git repo:
if [ "$git_push" = 'true' ]; then
    git -C "$dir_script" add --all
    git -C "$dir_script" commit -S -m "update.sh $(date +'%F %R')"
    git -C "$dir_script" push
fi

# vim:ft=bash
