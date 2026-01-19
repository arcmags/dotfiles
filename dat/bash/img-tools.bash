#!/bin/bash
## img-tools.bash ::

msg() { printf '\e[1;38;5;12m=> \e[0;38;5;15m%s\e[0m\n' "$*" ;}
msg_error() { printf '\e[1;38;5;9mE: \e[0;38;5;15m%s\e[0m\n' "$*" >&2 ;}
msg_to() { msg "$1$(printf ' \e[1;38;5;12m-> \e[0;38;5;15m%s' "${@:2}")" ;}
msg_warn() { printf '\e[1;38;5;11mW: \e[0;38;5;15m%s\e[0m\n' "$*" >&2 ;}

find_iregex() {
    [[ -z $1 ]] && return 1
    find -maxdepth 1 -type f -regextype egrep -iregex "$1" -printf '%f\n'
}

mv-number() {
    # TODO: make script, add checks, errors, etc
    [[ $1 == --help || $1 == -H ]] && cat <<'HELPDOC' && return
Usage:
  mv-number <file...>

Sort and number filenames. Names padded with appropriate leading zeros.
HELPDOC
    local d=1 f=1 arg= args=()
    mapfile -t args < <(printf '%s\n' "$@" | sort)
    d="${#args[@]}"; d="${#d}"
    for arg in "${args[@]}"; do
        [[ -f $arg ]] || { msg_warn "$arg: file not found, skipped"; continue ;}
        msg_to "$arg" "$(printf "%0${d}d.%s\n" "$f" "${arg##*.}")"
        mv "$arg" "$(printf "%0${d}d.%s\n" "$f" "${arg##*.}")"
        ((f++))
    done
}

img-upscale-test() {
    [[ $1 == --help || $1 == -H ]] && cat <<'HELPDOC' && return
Usage:
  img-upscale-test <image...>

Create multiple upscaled images with varying sharpen levels.
HELPDOC
    local arg= l= levels=(0.0 0.4 0.6 0.8 1.0 1.2 1.6 2.0)
    for arg in "$@"; do for l in "${levels[@]}"; do
        img-upscale -I -s "$l" "$arg"
    done; done
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

imgs-clear-exif() {
    [[ $1 == --help || $1 == -H ]] && cat <<'HELPDOC' && return
Usage:
  imgs-clear-exif

Clear exif metadata of all images in current directory.
HELPDOC
    local _imgs=()
    mapfile -t _imgs < <(find_iregex '.*\.(jpg|jpeg|webp|png|gif)')
    exiftool -overwrite_original -all= "${_imgs[@]}"
}

imgs-find-corrupted() {
    [[ $1 == --help || $1 == -H ]] && cat <<'HELPDOC' && return
Usage:
  imgs-find-corrupted

Scan current directory for corrupted images and move them to ./corrupted directory.
HELPDOC
    local _imgs=() _img= _i=0 _c=0 _dir='corrupted'
    mapfile -t _imgs < <(find_iregex '.*\.(jpg|jpeg|webp|png|gif)')
    for _img in "${_imgs[@]}"; do
        ((_i++))
        if ! identify -format '%w %h' "$_img" &>/dev/null; then
            mkdir -p "$_dir"
            mv "$_img" "$_dir"
            ((_c++))
        elif identify -format '%w %h' "$_img" 2>&1 | grep -Eqi '(corrupt|invalid)'; then
            mkdir -p "$_dir"
            mv "$_img" "$_dir"
            ((_c++))
        fi
        printf '\e[2K\r\e[1;38;5;12m=>\e[0;38;5;15m scanning: %d/%d\e[0m' $_i ${#_imgs[@]}
        [[ $_c -gt 0 ]] && printf '  \e[38;5;15mcorrupted: %d\e[0m' $_c
    done
    printf '\n'
}

imgs-find-small() {
    local _max_size=$((1600 * 1300 )) _img= _size= _i=0 _s=0
    if [[ -n $1 ]]; then
        if [[ $1 =~ ^([1-9][0-9]*)x([1-9][0-9]*)$ ]]; then
            _max_pixels=$((${BASH_REMATCH[1]} * ${BASH_REMATCH[2]}))
        elif [[ $1 =~ ^[1-9][0-9]*$ ]]; then
            _max_pixels="$1"
        else
            msg_error "$1: invalid image size"
        fi
    fi
    mapfile -t _imgs < <(find_iregex '.*\.(jpg|webp|png)')
    for _img in "${_imgs[@]}"; do
        ((_i++))
        _size="$(identify -format '%w %h' "$_img")"
        if [[ $((${_size% *} * ${_size#* })) -lt $_max_size ]];then
            mkdir -p small
            mv "$_img" small
            ((_s++))
        fi
        printf '\e[2K\r\e[1;38;5;12m=>\e[0;38;5;15m scanning: %d/%d\e[0m' $_i ${#_imgs[@]}
        [[ $_s -gt 0 ]] && printf '  \e[38;5;15msmall: %d\e[0m' $_s
    done
    printf '\n'
}

gif-upscale() {
    [ ! -f "$1" ] && return 1
    local dir_org="$PWD"
    local dir_tmp="$(mktemp -d)"
    local name="$(basename "$1")"
    local cmd_magick=(magick -loop 0)
    name="${name%.*}"
    cp "$1" "$dir_tmp"
    cd "$dir_tmp"
    msg_to "$1" 'ddd.png'
    magick "$1" -coalesce %03d.png
    img-upscale *.png
    mkdir ups
    mv *_u.png ups
    cd ups
    msg_to 'ddd.png' "${name}_u.gif"
    [[ -n $2 ]] && cmd_magick+=(-delay "$2")
    "${cmd_magick[@]}" *.png out.gif
    cp out.gif "${dir_org}/${name}_u.gif"
    cd "$dir_org"
    rm -r "$dir_tmp"
}

gif-upscale-4x() {
    [ ! -f "$1" ] && return 1
    local dir_org="$PWD"
    local dir_tmp="$(mktemp -d)"
    local name="$(basename "$1")"
    local cmd_magick=(magick -loop 0)
    name="${name%.*}"
    cp "$1" "$dir_tmp"
    cd "$dir_tmp"
    msg_to "$1" 'ddd.png'
    magick "$1" -coalesce %03d.png
    img-upscale -u4 *.png
    mkdir ups
    mv *_u.png ups
    cd ups
    msg_to 'ddd.png' "${name}_u.gif"
    [[ -n $2 ]] && cmd_magick+=(-delay "$2")
    "${cmd_magick[@]}" *.png out.gif
    cp out.gif "${dir_org}/${name}_u.gif"
    cd "$dir_org"
    rm -r "$dir_tmp"
}

# vim:ft=bash
