#!/bin/sh
## ~/.xinitrc ::

[ -f "$HOME/.xprofile" ] && . "$HOME/.xprofile"

session="${1:-i3}"
[ "$USER" = 'dery' ] && session="${1:-xfce}"

case "$session" in
    i3|i3wm) exec i3 ;;
    xfce|xfce4) exec startxfce4 ;;
esac

# vim:ft=sh
