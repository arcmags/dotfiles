#!/bin/bash

# source functions used by all i3bar scripts
. "$HOME/arc/.user/.config/i3/bin/i3-bar_all.sh"


##=============================  set-dafaults()  =============================##
# Set defaults for arch_usb.
set_defaults() {
    # network device
    str_net_mode="wired"                # network information display mode
    # network interface name:
    if (ip link | grep eth0: &>/dev/null); then
        netInterface='eth0'
    elif (ip link | grep wlan0: &>/dev/null); then
        netInterface='wlan0'
    else
        netInterface=$(ip address | \
            grep -Pom1 '.*?: \K[^:]+(?=: <BROADCAST)')
    fi
    netCmd=""                      # wifi network info handler command
    # cpu temp ranges (cooler than defaults)
    nTempGood=30
    nTempWarn=40
    nTempBad=60
}


##==============================  i3bar_loop()  ==============================##
# Main loop to continuously output json formatted information for i3bar.
i3bar_loop() {
    # main loop repeats every ~2 seconds
    while :
    do
        # file system info
        if [ $iFS -ge $iFSM ]; then
            mk_BFS
            iFS=-1
        fi
        ((iFS++))
        # network info
        if [ ${iNet} -ge ${iNetM} ]; then
            mk_bNetI
            iNet=-1
        fi
        ((iNet++))
        mk_BSys    # ~2 second delay
        mk_BNet
        mk_BTime
        # begin array element
        printf "[\n"
        # print blocks
        printf "$BNet"
        printf "$bPad"
        printf "$BFS"
        printf "$bPad"
        printf "$BSys"
        printf "$bPad"
        printf "$BTime"
        printf "$bEnd"
        # close array element
        printf "],\n"
    done
}


main

