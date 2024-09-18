#!/bin/bash
## fsort.bash ::

print_help() { cat <<'HELPDOC'
NAME
    fsort.bash - rename/sort files by creation date

SYNOPSIS
    mv-created.bash [FILE...]

DESCRIPTION
    Rename files to their created/modified date.
    Attempt to read any metadata creation tags.
HELPDOC
}; [ "$0" != "$BASH_SOURCE" ] && { print_help; return 0 ;}

## control ::
deps=(exiftool)

## functions ::
error() { msg_error "$@"; exit 5 ;}
msg() { printf '\e[1;38;5;12m=> \e[0;38;5;15m%s\e[0m\n' "$*" ;}
msg_error() { printf '\e[1;38;5;9mE: \e[0;38;5;15m%s\e[0m\n' "$*" >&2 ;}
msg_to() { msg "$1$(printf ' \e[1;38;5;12m-> \e[0;38;5;15m%s' "${@:2}")" ;}
msg_warn() { printf '\e[1;38;5;11mW: \e[0;38;5;15m%s\e[0m\n' "$*" >&2 ;}

## main() ::
trap exit INT
for dep in "${deps[@]}"; do command -v "$1" &>/dev/null "$dep" || error "missing dep: $dep"; done

for arg in "$@"; do
    [ ! -f "$arg" ] && msg_warn "not found: $arg" && continue

    exif="$(exiftool "$arg")"
    date="$(grep -Poim1 '^Create[^:]*:\s*\K[^-]*' <<<"$exif")"
    [ -z "$date" ] && date="$(grep -Poim1 '^File Modification Date[^:]*:\s*\K[^-]*' <<<"$exif")"
    date="$(sed -Ee 's/^([0-9]+):([0-9]+):([0-9]+)/\1-\2-\3/' -e 's/ /_/' -e 's/://g' <<<"$date")"

    ext="${arg#*.}"; ext="${ext,,}"
    [ "$ext" = jpeg ] || file -b "$dir_in/$file_in" | grep -q JPEG && ext=jpg
    ext=".$ext"

    file_out="$date$ext"
    if [ -f "$file_out" ]; then
        n=1; while [ -f "${date}_$n$ext" ]; do ((n++)); done
        file_out="${date}_$n$ext"
    fi

    mv "$arg" "$file_out"
    msg_to "$arg" "$file_out"
done

# vim:ft=bash
