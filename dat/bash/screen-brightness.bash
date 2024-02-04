#!/bin/bash

## screen-brightness.bash ::
# Adjust Lenovo ThinkPad screen brightness.

if [[ $1 =~ ^[0-9]+$ ]] && [ $1 -le 100 ] && [ $1 -gt 0 ]; then
    echo $(( 4794* $1 /100 )) > /sys/class/backlight/intel_backlight/brightness
fi

# vim:ft=bash
