#!/bin/bash
## rgb.txt.bash ::

[[ -z "$1" ]] && exit
[[ -f "$1" ]] || exit

while read -r line; do
    [[ "$line" =~ ^([0-9]+)\ +([0-9]+)\ +([0-9]+)[^A-Za-z0-9]+(.*) ]]
    printf '%-20s  %02x%02x%02x  %-12s\n' "${BASH_REMATCH[4]}" "${BASH_REMATCH[@]:1:3}" \
        "${BASH_REMATCH[1]},${BASH_REMATCH[2]},${BASH_REMATCH[3]}"
done < "$1"

# vim:ft=bash
