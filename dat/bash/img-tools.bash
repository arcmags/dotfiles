#!/bin/bash
## img-tools.bash ::

## internal ::
msg() {
	[ "$flag_quiet" = 'true' ] && return
	printf "\e[1;38;5;12m==> \e[0;38;5;15m$1\e[0m\n" "${@:2}"
}

msg_error() {
	printf "\e[1;38;5;9m==> ERROR: \e[0;38;5;15m$1\e[0m\n" "${@:2}" >&2
}

## functions ::
img-sharpen-test() {
    local values=(0.8 1 1.2 1.4 1.8 2.2 2.8)
    local ext='png'
    if [ "$1" = '-J' ]; then
        shift
        ext='jpg'
    fi
    for v in "${values[@]}"; do
        for a in "$@"; do
            convert "$a" -sharpen 0x"$v" \
              "${a%%.*}_s$(printf '%.2s' "$(sed 's/\.//' <<<"$v")0").$ext"
        done
    done
}

img-despeckle() {
    local file_base file_dir file_ext file_name
    for a in "$@"; do
        file_dir="$(cd "$(dirname "$a")" && pwd)"
        file_name="$(basename "$a")"
        file_base="${file_name%.*}"
        if [ "${file_name:0:1}" = '.' ]; then
            file_base="${file_name:1}"
            file_base=".${file_base%.*}"
        fi
        file_ext="${file_name:${#file_base}}"
        convert "$a" -despeckle -quality 92 "${file_dir}/${file_base}d${file_ext}"
    done
}

img-test-feh() {
    file_base="${1%.*}"
    img-upscale -P "$1"
    img-sharpen-test -J "$file_base"_u20*.png
    feh "$file_base"*
}

# vim:ft=bash
