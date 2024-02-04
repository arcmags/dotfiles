#!/bin/bash
##============================  i3-info-gaps.sh  =============================##
# Print tree information about workspace gaps.
i3-msg -t get_tree | grep -Po '"name":"\K[0-9]+.*?"gaps".*?}' |\
    sed -E -e 's/("|),"num":[0-9]+,"gaps":\{/  /g' -e 's/}//g'
