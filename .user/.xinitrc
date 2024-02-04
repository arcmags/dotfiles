#!/bin/sh
## ~/.xinitrc ::

[ -f "$HOME/.xprofile" ] && . "$HOME/.xprofile"

session="${1:-i3}"
case "$session" in
    i3|i3wm)
        exec i3 ;;
    xfce|xfce4)
        xset s noblank -dpms
        exec startxfce4 ;;
esac

# vim:ft=sh
