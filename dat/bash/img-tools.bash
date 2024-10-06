#!/bin/bash
## img-tools.bash ::

msg() { printf '\e[1;38;5;12m=> \e[0;38;5;15m%s\e[0m\n' "$*" ;}
msg_error() { printf '\e[1;38;5;9mE: \e[0;38;5;15m%s\e[0m\n' "$*" >&2 ;}
msg_to() { msg "$1$(printf ' \e[1;38;5;12m-> \e[0;38;5;15m%s' "${@:2}")" ;}
msg_warn() { printf '\e[1;38;5;11mW: \e[0;38;5;15m%s\e[0m\n' "$*" >&2 ;}

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

gif-upscale() {
    [ ! -f "$1" ] && return 1
    local dir_org="$PWD"
    local dir_tmp="$(mktemp -d)"
    local name="$(basename "$1")"
    name="${name%.*}"
    cp "$1" "$dir_tmp"
    cd "$dir_tmp"
    msg_to "$1" '...png'
    magick *.gif -coalesce %03d.png
    img-upscale *.png
    mkdir ups
    mv *_u2*.png ups
    cd ups
    msg_to '...png' "${name}_u.gif"
    magick *.png -delay 10 -loop 0 out.gif
    cp out.gif "${dir_org}/${name}_u.gif"
    cd "$dir_org"
    rm -r "$dir_tmp"
}

# vim:ft=bash
