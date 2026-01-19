#!/bin/bash
## ~/.config/i3/wallpaper.bash ::

## settings ::
readonly dir_wallpapers="$UDIR/dat/wallpapers"
readonly cmd_find=(find "$dir_wallpapers" -maxdepth 1 -type f -iname '*.jpg' -o -iname '*.png')

## internal functions/variables ::
readonly -a deps=(feh magick)
args=("$@") imgs=() img= img_tmp=

# tests:
is_img() { [[ -f $1 ]] && identify "$1" &>/dev/null ;}
is_cmd() { command -v "$1" &>/dev/null ;}

## main ::
for d in "${deps[@]}"; do is_cmd "$d" || exit 3; done
[[ -n $DISPLAY ]] || exit 3
[[ -d $dir_wallpapers ]] || exit 3

[[ -z $1 ]] && mapfile -t args < <("${cmd_find[@]}")
for a in "${args[@]}"; do is_img "$a" || continue; imgs+=("$a"); done
[[ ${#imgs[@]} -eq 0 ]] && exit 3

img="${imgs[((RANDOM % ${#imgs[@]}))]}"
if [[ $(xrandr | grep -c ' connected ') -gt 1 ]]; then
    s=$(identify -format '%wx%h' "$img")
    if [[ $((${s%x*} * 1000 / (${s#*x} * 100))) -gt 30 ]]; then
        feh --bg-fill --no-xinerama "$img"
    else
        img_tmp="$(mktemp -t "XXX.${img##*.}")"
        magick "$img" -flop "$img_tmp"
        feh --bg-fill "$img" "$img_tmp"
        rm "$img_tmp"
    fi
else
    feh --bg-fill "$img"
fi

# vim:ft=bash
