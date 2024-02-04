#!/bin/bash
##==========================  i3-info-windows.sh  ============================##
# Print tree information on all window.
#i3-msg -t get_tree | \
    #grep -oP '.*,\K\{.*focused":true.*?}(?=,{)' | \
    #sed -e 's/,"/,\n"/g' | jq

json="`i3-msg -t get_tree`"

titles=`echo $json | grep -oP '.*?\K{.*?focused".*?}(?=,{)' | grep -Po '"title":"\K.*?(?=")'`

IFS=$'\n'

for title in $titles; do
    printf "$title\n"
    echo $json | grep -oP '.*?\K{.*?focused".*?}(?=,{)' | \
    sed -e 's/},{"/},{"/g' | grep $title | jq
done

