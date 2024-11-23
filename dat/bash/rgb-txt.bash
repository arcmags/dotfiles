#!/bin/bash
## rgb-txt.bash ::

print_help() { cat <<'HELPDOC'
NAME
    rgb-txt.bash - parse rgb.txt

SYNOPSIS
    rgb-txt.bash [file]

DESCRIPTION
    This script takes the xorg color file rgb.txt as stdin or an argument and
    prints sorted colors with hex and rgb values to stdout. Color names
    containing spaces or X11 are removed.

    <https://gitlab.freedesktop.org/xorg/app/rgb/raw/master/rgb.txt>
HELPDOC
}
[[ "$0" != "$BASH_SOURCE" ]] && print_help && return 0
[[ "$1" =~ ^(-H|--help)$ ]] && print_help && exit

[[ -n "$1" && ! -f "$1" ]] && exit
while read -r line; do
    [[ "$line" =~ ^([0-9]+)\ +([0-9]+)\ +([0-9]+)[^A-Za-z0-9]+(.*) ]]
    printf '%-20s  %02x%02x%02x  %-12s\n' "${BASH_REMATCH[4]}" "${BASH_REMATCH[@]:1:3}" \
        "${BASH_REMATCH[1]},${BASH_REMATCH[2]},${BASH_REMATCH[3]}"
done < "${1:-/dev/stdin}" | sort -Vfk1,1 | sed -e '/[^ ] [^ ]/d' -e '/X11/d'
