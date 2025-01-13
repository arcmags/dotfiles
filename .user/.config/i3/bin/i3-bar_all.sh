#!/bin/bash
##=============================  i3-bar_all.sh  ==============================##
# by Chris Magyar.                                       c.magyar.ec@gmail.com #
# Free as in speech.                                 Ride it like it's stolen! #
##============================================================================##
#
# Required packages: acpi, sysstat, lm-sensors, font-awesome, jq


##=================================  main()  =================================##
# Declare all variables, call functions to set defaults, build constant blocks,
# and start loop.
main() {
    # arrays
    local fsArr=()                  # file-system information
    local memArr=()                 # memory information
    local netArrO=()                # previous network speeds
    local netArr=()                 # network down/up (bytes), sys-time (ms)
    # commands
    local netCmd=                   # network info handler command
    # individual blocks
    local bEnd=                     # last block
    local bNetD=                    # network down speed block
    local bNetI=                    # network information block
    local bNetIP=                   # network ip address block
    local bNetU=                    # network up speed block
    local bPad=                     # spacer block
    local bSep1=                    # large separator block
    local bSep2=                    # small separator block
    # icon blocks
    local biArch=                   # arch icon block
    local biCPU=                    # cpu icon block
    local biBatt0=                  # battery empty icon block
    local biBatt1=                  # battery 1/4 icon block
    local biBatt2=                  # battery 1/2 icon block
    local biBatt3=                  # battery 3/4 icon block
    local biBatt4=                  # battery full icon block
    local biDate=                   # calendar icon block
    local biDrive=                  # hhd icon block
    local biHome=                   # home icon block
    local biMem=                    # memory icon block
    local biNetD=                   # down arrow icon block
    local biNetIP=                  # globe icon block
    local biNetU=                   # up arrow icon block
    local biNet=                    # network icon block
    local biPower=                  # power icon block
    local biTemp=                   # shield icon block
    local biTime=                   # clock icon block
    local biUSB=                    # usb icon block
    # block sets
    local BSys=                     # cpu and memory blocks
    local BTime=                    # date and time blocks
    local BFS=                      # file system blocks
    local BNet=                     # network blocks
    local BBatt=                    # battery blocks
    # colors
    local cBad=                     # color bad
    local cColon=                   # color colon
    local cPlain=                   # color field
    local cGood=                    # color good
    local cIcon=                    # color icon
    local cSep=                     # color separator
    local cSlash=                   # color slash
    local cWarn=                    # color bad
    # integers
    local temp=                     # cpu temp
    local tempG=                    # cpu good temp range
    local tempW=                    # cpu warning temp range
    local tempB=                    # cpu high temp range
    local fs=                       # file system total (bytes)
    local fsU=                      # file system used (bytes)
    local mem=                      # total memory installed (bytes)
    local memU=                     # memory used (bytes)
    local netD=                     # network download speed (bytes/sec)
    local netU=                     # network upload speed (bytes/sec)
    local pad=                      # width of spacer (px)
    local batt=                     # battery remaining percent
    # json code snippets
    local jEnd=                     # json code for ending a block
    local jStart=                   # json code for starting a block
    local jColon=                   # json code for :
    local jSlash=                   # json code for /
    # overridden shell variables
    local S_COLORS="never"          # turn off mpstat colors
    # cycle counters
    local iFS=                      # counter for file system info
    local iFSM=                     # cycles for file system info repeat
    local iNet=                     # counter for network info
    local iNetM=                    # cycles for network info repeat
    local iNetIP=                   # inner cycles of network info
    local iNetIPM=                  # inner cycles for network IP repeat ping
    # strings
    local sCPU=                     # cpu load percent
    local sDate=                    # date
    local sIP=                      # ip address
    local sMem=                     # total memory installed
    local sMemU=                    # memory used
    local sNetD=                    # network down speed
    local netInterface=             # network interface name
    local netName="none"            # network name
    local netNameO=                 # network name at time a
    local sNetU=                    # network up speed
    local sTime=                    # time
    local sBatt=                    # battery remaining percent
    # colors
    local cFS=                      # filesystem color
    local cTemp=                    # cpu temp color
    local cCPU=                     # cpu load color
    local cMem=                     # memory usage color
    local cBatt=                    # battery charge color
    # default colors
    cPlain="$(xrdb -query | grep -Po '^\*\.color7:\s+\K.*')"                # color field
    cBad="$cPlain"                  # color bad
    cColon="$(xrdb -query | grep -Po '^\*\.color12:\s+\K.*')"                # color colon
    cGood="$cPlain"                 # color good
    cIcon="$cColon"                 # color icon
    cSep="$(xrdb -query | grep -Po '^\*\.color8:\s+\K.*')"                  # color separator
    cSlash="$cColon"                # color slash
    cWarn="$cPlain"                 # color bad
    # default spacer
    pad=32                          # width of spacer (px)
    # default cycle counters
    iFSM=8                          # cycles for file system info repeat
    iNetM=9                         # cycles for network info repeat
    iNetIPM=4                       # inner cycles for ip info repeat
    # default cpu temp ranges
    tempG=35
    tempW=45
    tempB=60
    # set computer specific defaults
    set_defaults
    # make constants
    mk_constants
    # initialize i3bar
    i3bar_start
    # start i3bar infinite loop
    i3bar_loop
    exit 0
}


##==============================  i3bar_start()  =============================##
# Initialize i3bar.
i3bar_start() {
    # set all counters to max
    iFS=$iFSM
    iNet=$iNetM
    iNetIP=$iNetIPM
    # initial total memory reading
    memArr=( `free -b | tail -2 | head -1` )
    mem="${memArr[1]}"
    sMem="`int_round $mem 0`"
    # initial network state
    netNameO="initial_blank_name"
    # initial network total bytes down, total bytes up, and system time (ms)
    netArrO=( `cat \
        "/sys/class/net/$netInterface/statistics/rx_bytes" \
        "/sys/class/net/$netInterface/statistics/tx_bytes"`
        `date +%s%N | cut -c1-13` )
    # let i3bar know input is in json
    printf '{"version":1}'
    printf "\n"
    # initialize array stream
    printf "[\n"
    printf "[],\n"
}


##================================  mkJtext()  ===============================##
# Make json text to include inside a block started by mkBs.
#   $1=[string] - text
#   $2=[color] (default=${cGood})
#   $3=[normal,bold,heavy] (default=normal)
mkJtext() {
    printf "<span color='${2:-${cGood}}'"
    if [ -n "$3" ]; then
        printf ",\"font_weight\":\"$3\""
    fi
    printf ">%s</span>" "$1"
}


##=================================  mkBs()  =================================##
# Make generic block start.
#   $1=[string] - string of the same length as minimum block width (default='')
#   $2=[left|center|right] - text alignment in block (default=center)
mkBs() {
    printf "${jStart}"
    if [ -n "$1" ]; then
        printf "\"min_width\":\"$1\",\n    \"align\":\"${2:-center}\",\n    "
    fi
    printf '"full_text":"'
}


##=============================  mk_constants()  =============================##
# Make constant i3bar blocks.
mk_constants() {
    # local json strings for building blocks
    local bB='  { \n    "markup":"pango",\n    "separator":false,\n    '
    local bE='</span>"\n  },\n'
    local sep0='"separator_block_width":0,\n    '
    local sep3='"separator_block_width":3,\n    '
    local bIB="$bB$sep0\"full_text\":\"<span "
    local bIAwesome="$bIB color=\'$cIcon\'><span font=\'FontAwesome\'>"
    local bIOpenLogos="$bIB color=\'$cIcon\'><span font=\'OpenLogos\'>"
    local bIE="</span>:$bE"
    local bSB="$bB$sep3\"full_text\":\"<span color='${cSep}'>"
    # build icon blocks
    biArch="${bIAwesome}${bIE}"
    biBatt0="${bIAwesome}${bIE}"
    biBatt1="${bIAwesome}${bIE}"
    biBatt1="${bIAwesome}${bIE}"
    biBatt3="${bIAwesome}${bIE}"
    biBatt4="${bIAwesome}${bIE}"
    biCPU="${bIAwesome}${bIE}"
    biDate="${bIAwesome}${bIE}"
    biDB="${bIAwesome}${bIE}"
    biDrive="${bIAwesome}${bIE}"
    biHome="${bIAwesome}${bIE}"
    biMem="${bIAwesome}${bIE}"
    biNet="${bIAwesome}${bIE}"
    biNetD="${bIAwesome}${bIE}"
    biNetIP="${bIAwesome}${bIE}"
    biNetU="${bIAwesome}${bIE}"
    biPower="${bIAwesome}${bIE}"
    biTemp="${bIAwesome}${bIE}"
    biTime="${bIAwesome}${bIE}"
    biUSB="${bIAwesome}${bIE}"
    # build separator and pad blocks
    bEnd="$bB$sep0\"full_text\":\"<span color='${cSep}'>┃</span>\"\n  }\n"
    bPad="$bB$sep0\"min_width\":$pad,\n    \"full_text\":\" \"\n  },\n"
    bSep1="${bSB}┃${bE}"
    bSep2="$bSep1"
    jEnd='"\n  },\n'
    jStart="$bB$sep3"
    jColon="<span color='${cColon}' font_weight='bold'>:</span>"
    jSlash="<span color='${cSlash}' font_weight='bold'>/</span>"
}


##===============================  mk_bNetI()  ===============================##
mk_bNetI() {
    # wifi info
    if [[ "${str_net_mode}" == "wifi" ]]; then
        if netName=`${netCmd} | grep --color=never '*'`; then
            netName="${netName#*${netInterface}-}"
        else
            netName="none"
        fi
        # do if wifi network status has changed
        if [[ "${netName}" != "${netNameO}" ]]; then
            block_wifi="${biNet}`mkBs`"
            # do if not connected to a wifi network
            if [[ "${netName}" == "none" ]]; then
                block_wifi+="`mkJtext none ${cBad}`"
            # do if connected to a wifi network
            else
                # shorten network name to 24 characters
                if [ ${#netName} -gt 24 ]; then
                    netName="${netName:0:21}..."
                fi
                block_wifi+="`mkJtext "${netName}"`"
                iNetI=${iNetIPM}
            fi
            block_wifi+="${jEnd}"
            netNameO="${netName}"
        fi
        # do if connected to a network and iNetIPM is surpassed
        if [[ "${netName}" != "none" ]] && [ ${iNetIP} -ge ${iNetIPM} ];then
            mk_bNetIP
            iNetIP=0
        fi
        ((iNetIP++))
    else
        if [ ${iNetIP} -ge ${iNetIPM} ];then
            mk_bNetIP
            iNetIP=0
        fi
        ((iNetIP++))
    fi
}


##==============================  mk_bNetIP()  ===============================##
# Make IP/internet connection block.
mk_bNetIP() {
    bNetIP="${biNetIP}`mkBs`"
    sIP="offline"
    if (ping -q -c 1 -W 3 google.com &> /dev/null); then
        sIP=$(curl -s -m 4 -4 api.ipify.org) || \
            sIP=$(curl -s -m 6 -4 icanhazip.com)
    fi
    if [[ "$sIP" == "offline" ]]; then
        bNetIP+="`mkJtext offline ${cBad}`"
    elif [[ ! "${sIP}" =~ ^([0-9]|[a-f]|[A-F]|\.|\:)+$ ]]; then
        bNetIP+="`mkJtext 'no_ip' ${cWarn}`"
        iNetIP=$(($iNetIP-1))
    else
        bNetIP+="`mkJtext ${sIP}`"
        iNetIP=0
    fi
    bNetIP+="${jEnd}${bSep2}"
}


##===============================  mk_BNet()  ================================##
# Make network speed blocks.
mk_BNet() {
    # network total bytes down, total bytes up, and system time (ms)
    netArr=( `cat "/sys/class/net/${netInterface}/statistics/rx_bytes" \
        "/sys/class/net/${netInterface}/statistics/tx_bytes"` `date +%s%N | \
        cut -c1-13` )
    # calculate down and up speeds in bytes/sec
    netD=$(( (${netArr[0]}-${netArrO[0]})*1000/(${netArr[2]}-${netArrO[2]}) ))
    netU=$(( (${netArr[1]}-${netArrO[1]})*1000/(${netArr[2]}-${netArrO[2]}) ))
    # reset network speed interval
    netArrO=( ${netArr[*]} )
    sNetD="`int_round $netD`B/s"
    sNetU="`int_round $netU`B/s"
    clr_net_down="$cPlain"
    clr_net_up="$cPlain"
    # make blocks
    bNetD="$biNetD`mkBs x.xxXB/s right; mkJtext $sNetD`$jEnd"
    bNetU="$biNetU`mkBs x.xxXB/s right; mkJtext $sNetU`$jEnd"
    if [[ "${netName}" != "none" ]]; then
        BNet="$bSep1${block_wifi}$bSep2$bNetIP$bNetD$bSep2$bNetU$bSep1"
    else
        BNet="$bSep1$bNetIP$bNetD$bSep2$bNetU$bSep1"
    fi
}


##================================  mk_BFS()  ================================##
# Make file system blocks.
mk_BFS() {
    # file system info array: details on mounted file systems (other that /boot)
    fsArr=( `df -B 1 --output=source,target,used,size | \
        grep ^/dev | grep -v /boot` )
    # parse file system array and build blocks
    BFS="${bSep1}"
    local i=0
    while [ -n "${fsArr[$i]}" ]; do
        str_fs_tmp="/${fsArr[$((i+1))]##*/}"
        # add icon blocks
        case ${str_fs_tmp} in
            /ntfs-2TB)    BFS+="$biDrive" ;;
            /home)        BFS+="$biHome" ;;
            /)            BFS+="$biArch" ;;
            *)            BFS+="$biUSB" ;;
        esac
        fsU="${fsArr[$((i+2))]}"
        fs="${fsArr[$((i+3))]}"
        cFS="$cPlain"
        str_fs_used="`int_round $fsU`"
        str_fs_total="`int_round $fs`"
        BFS+="`mkBs x.xxA/x.xxA; mkJtext $str_fs_used $cFS`$jSlash"
        BFS+="`mkJtext $str_fs_total $cFS`$jEnd"
        if [ -n "${fsArr[$((i+5))]}" ]; then
            BFS+="${bSep2}"
        fi
        i=$((i+4))
    done
    BFS+="${bSep1}"
}


##===============================  mk_BSys()  ================================##
# Make CPU load, CPU temp, and memory blocks.
mk_BSys() {
    # cpu load from mpstat with a 1 second interval taken twice
    str_cpu_idle="`mpstat 1 2 | tail -2 | head -1`"
    str_cpu_idle="${str_cpu_idle##* }"
    sCPU="`echo "scale=1; (100 - ${str_cpu_idle}+0.05)/1" | bc`"
    # parse percent
    if [[ "${sCPU}" == "0" ]]; then
        sCPU="0.0"
    elif [ ${#sCPU} -eq 2 ]; then
        sCPU="0${sCPU}"
    elif [ ${#sCPU} -eq 4 ]; then
        sCPU="${sCPU:0:2}"
    elif [ ${#sCPU} -eq 5 ]; then
        sCPU="100"
    fi
    cCPU="$cPlain"
    sCPU+='%%'
    # cpu temp from sensors
    str_cpu_temp=`sensors 2>/dev/null | grep -Po '.*Core \d\d?.*?\+\K\d\d?(?=\.)'`
    [ -z "$str_cpu_temp" ] && str_cpu_temp=`sensors 2>/dev/null | grep -Po '.*Tctl: *\+\K\d\d?(?=\.)'`
    temp=0
    local c=0
    for t in $str_cpu_temp; do
        temp=$(( $temp + $t ))
        ((c++))
    done
    if [ $c -gt 0 ]; then
        temp="$(( $temp / $c ))"
        str_cpu_temp="${temp}°C"
        cTemp="$cPlain"
    else
        str_cpu_temp="-"
        cTemp='#000000'
    fi
    # call free to get memory info
    memArr=( `free -b | tail -2 | head -1` )
    memU="${memArr[2]}"
    sMemU="`int_round ${memU}`"
    cMem="$cPlain"
    # make blocks
    BSys="$bSep1$biCPU`mkBs xxxp; mkJtext $sCPU $cCPU`$jEnd$bSep2$biTemp"
    BSys+="`mkBs xxDC; mkJtext $str_cpu_temp $cTemp`$jEnd$bSep2$biMem"
    BSys+="`mkBs xx.xA/x.xxA; mkJtext $sMemU $cMem`$jSlash"
    BSys+="`mkJtext $sMem $cMem`$jEnd$bSep1"
}


##===============================  mk_BBatt()  ===============================##
# Make battery block.
mk_BBatt() {
    batt="`acpi -b | grep -Po 'Battery 0.*?, \K[0-9]+(?=%)'`"
    #if [ ${batt} -ge 99 ]; then
        #batt=100
    #fi
    sBatt="${batt}%%"
    BBatt="${bSep1}"
    if [ ${batt} -gt 90 ]; then
        BBatt+="$biBatt4"
    elif [ ${batt} -gt 65 ]; then
        BBatt+="$biBatt3"
    elif [ ${batt} -gt 40 ]; then
        BBatt+="$biBatt2"
    elif [ ${batt} -gt 15 ]; then
        BBatt+="$biBatt1"
    else
        BBatt+="${biBatt0}"
    fi
    cBatt="$cPlain"
    BBatt+="`mkBs xxxP; mkJtext $sBatt $cBatt`$jEnd$bSep1"
}


##===============================  mk_BTime()  ===============================##
# Make date and time blocks.
mk_BTime() {
    sTime="`date "+%H:%M %F"`"
    sDate="${sTime#* }"
    sTime="${sTime% *}"
    BTime="$bSep1$biDate`mkBs xxxx-xx-xx; mkJtext "${sDate}"`$jEnd$bSep2"
    BTime+="$biTime`mkBs xx:xx; mkJtext "$sTime"`$jEnd"
}


##==============================  int_round()  ===============================##
# Round an integer input to 4-5 characters with metric prefix (K,M,G,T,P,E).
#   $1=[integer]
int_round() {
    local int_in="${1:-0}"
    if [ ${int_in} -lt 1000 ]; then
        printf "${int_in}"
    else
        local mod_1000=$(( ( ${#int_in} - 1 ) % 3 ))
        if [ ${mod_1000} -eq 0 ]; then
            numfmt --to=si --format "%.2f" --round=nearest ${int_in}
        elif [ ${mod_1000} -eq 1 ]; then
            numfmt --to=si --format "%.1f" --round=nearest ${int_in}
        else
            numfmt --to=si --format "%.0f" --round=nearest ${int_in}
        fi
    fi
}

# vim:ft=bash
