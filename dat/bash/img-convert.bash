#!/bin/bash

## img-convertbash ::

## internal ::
msg() {
	[ "$flag_quiet" = 'true' ] && return
	printf "\e[1;38;5;12m==> \e[0;38;5;15m$1\e[0m\n" "${@:2}"
}

msg_error() {
	printf "\e[1;38;5;9m==> ERROR: \e[0;38;5;15m$1\e[0m\n" "${@:2}" >&2
}

# config:
noise=1
height=2500

## main ::
for img in "$@"; do
    if ! identify "$img" &>/dev/null; then
        msg_error "$img"
        continue
    fi
    img_dir="$(cd "$(dirname "$img")" && pwd)"
    img_name="$(basename "$img")"
    img_base="${img_name%.*}"
    if [ "${img_name:0:1}" = '.' ]; then
        img_base="${img_name:1}"
        img_base=".${img_base%.*}"
    fi
    img_ext="${img_name:${#img_base}}"
    img_w="$(identify -format '%w %h' "$img")"
    img_h="${img_w#* }"
    img_w="${img_w% *}"
    img-upscale -P -n "$noise" -s 4 "$img"
    convert "$img_base"_s4n"$noise"*.png -resize x"$height" "$img_base"_c"$noise".jpg
    rm "$img_base"_s4n"$noise"*.png
done

# vim:ft=bash
