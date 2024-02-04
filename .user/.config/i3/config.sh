#!/bin/sh

## config.sh :: i3 startup config script:
# depends: feh, imagemagick

dir_img="$UDIR/dat/img/pix"
cmd_feh='feh --bg-fill --force-aliasing'

case $(printf '0\n1\n2\n3' | sort -R | head -n1) in
    0) $cmd_feh --no-xinerama "$dir_img/ChinaMountains.png" >/dev/null 2>&1 ;;
    1) $cmd_feh --no-xinerama "$dir_img/CyberpunkCity.png" >/dev/null 2>&1 ;;
    2) $cmd_feh --no-xinerama "$dir_img/UnderTheBridge.png" >/dev/null 2>&1 ;;
    3) $cmd_feh "$dir_img/CityCorner.png" >/dev/null 2>&1 ;;
esac
