#!/bin/bash

## user_skel.bash ::
# Generate user_skel.bash.tar.asc from files. Copy to every dir in dirs.

files=(
    bin/uln
    bin/usync
    .user/.ssh/config
    .user/.ssh/id_rsa.asc
    .user/.ssh/id_rsa.pub
)
dirs=(
    dat/gpg
    www
)

## functions ::
msg() {
    printf "\e[1;38;5;12m==> \e[0;38;5;15m$1\e[0m\n" "${@:2}"
}

msg_add() {
    printf "\e[38;5;10m  + \e[38;5;15m$1\e[0m\n" "${@:2}"
}

msg_error() {
    printf "\e[38;5;9m E: \e[0;38;5;15m$1\e[0m\n" "${@:2}"
}

## main() ::
shopt -s dotglob

cd "$UDIR"
for file in "${files[@]}"; do if [ ! -f "$file" ]; then
    msg_error "file not found: $file"
    exit 3
fi; done
msg 'building user_skel.tar.asc ...'

dir_tmp="$(mktemp -d)"
trap "rm -rf $dir_tmp" EXIT

mapfile -t -O ${#files[@]} files < <(find . -name '.usync' -or -name '.uln' 2>/dev/null)
for file in "${files[@]}"; do
    if cp --parents "$file" "$dir_tmp" &>/dev/null; then
        msg_add "$file"
    else
        msg_error "$file"
    fi
done

cd "$dir_tmp"
bsdtar caf user_skel.tar *
if ! gpg -q -c -o user_skel.tar.asc user_skel.tar &>/dev/null; then
    msg_error 'gpg: user_skel.tar.asc'
    exit 2
fi

for dir in "${dirs[@]}"; do
    if cp user_skel.tar.asc "$UDIR/$dir" &>/dev/null; then
        msg "$UDIR/$dir/user_skel.tar.asc"
    else
        msg_error "$UDIR/$dir/user_skel.tar.asc"
    fi
done

# vim:ft=bash
