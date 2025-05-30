#!/bin/bash
## img-web.bash ::
# Generate thumbnails and web-sized images from input arguments.

## config ::
web_s_max=2500
web_q_min=80
web_q_max=90
thumb_w=200
thumb_h=150

## internal ::
msg() {
    [ "$flag_quiet" = 'true' ] && return
    printf "\e[1;38;5;12m==> \e[0;38;5;15m$1\e[0m\n" "${@:2}"
}

msg_error() {
    printf "\e[1;38;5;9m==> ERROR: \e[0;38;5;15m$1\e[0m\n" "${@:2}" >&2
}

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
    mkdir -p "$img_dir/web/thumb"
    img_web="${img_dir}/web/${img_base}_web$img_ext"
    img_thumb="${img_dir}/web/thumb/${img_base}_thumb$img_ext"
    msg "$img_name"
    if [ $img_w -le $web_s_max ] && [ $img_h -le $web_s_max ]; then
        cp "$img" "$img_web"
    else
        if [ "$img_w" -ge "$img_h" ]; then
            magick "$img" -resize "${web_s_max}x" -quality $web_q_max "$img_web"
        else
            magick "$img" -resize "x${web_s_max}" -quality $web_q_max "$img_web"
        fi
    fi
    magick "$img" -resize "${thumb_w}x" -quality 75 "$img_thumb"
    thumb_w_tmp="$(identify -format '%w %h' "$img_thumb")"
    thumb_h_tmp="${thumb_w_tmp#* }"
    thumb_w_tmp="${thumb_w_tmp% *}"
    if [ $thumb_h_tmp -lt $thumb_h ]; then
        magick "$img" -resize "x${thumb_h}" -quality 75 "$img_thumb"
        thumb_w_tmp="$(identify -format '%w %h' "$img_thumb")"
        thumb_h_tmp="${thumb_w_tmp#* }"
        thumb_w_tmp="${thumb_w_tmp% *}"
        magick "$img" -resize "x${thumb_h}" \
            -crop "${thumb_w}x${thumb_h}+$(((thumb_w_tmp - thumb_w)/2))+0" \
            -quality 75 "$img_thumb"
    elif [ $thumb_h_tmp -gt $thumb_h ]; then
        magick "$img" -resize "${thumb_w}x" -quality 75 "$img_thumb"
        thumb_w_tmp="$(identify -format '%w %h' "$img_thumb")"
        thumb_h_tmp="${thumb_w_tmp#* }"
        thumb_w_tmp="${thumb_w_tmp% *}"
        magick "$img" -resize "${thumb_w}x" \
            -crop "${thumb_w}x${thumb_h}+0+$(((thumb_h_tmp - thumb_h)/3))" \
            -quality 75 "$img_thumb"
    fi
    exiftool -quiet -overwrite_original -all= "$img_web" "$img_thumb"
done

# vim:ft=bash
