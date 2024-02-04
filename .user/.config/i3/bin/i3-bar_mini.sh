#!/bin/bash
##===================================  magyar's i3-bar script  ===================================##
# 
# required packages: acpi (for battery info), bc, sysstat
# required AUR packages: ttf-font-awesome, ttf-openlogos-archupdate

##================================  USER SET DEFAULTS  =================================##
set_defaults() {
    # network device
    str_net_interface="wlp2s0"
    # colors
    clr_bad="#ff0000"                   # color bad
    clr_colon="#7777bb"                 # color colon
    clr_field="#7777bb"                 # color field
    clr_good="#00ff00"                  # color good
    clr_icon="#7777bb"                  # color icon
    clr_separator="#666666"             # color separator
    clr_slash="#7777bb"                 # color slash
    clr_warning="#ffff00"               # color bad
    # spacer
    int_spacer=32                       # width of spacer (px)
    # cycle counters
    cnt_fs_cycle_max=8                  # cycles for file system info repeat
    cnt_net_cycle_max=23                # cycles for network info repeat
    # cpu temp ranges
    int_cpu_temp_good=30
    int_cpu_temp_warn=40
    int_cpu_temp_bad=60
}


##=======================================  MAIN  =======================================##
main() {
    # arrays
    local arr_fs=()                     # array of file-system information
    local arr_mem=()                    # array of memory information
    local arr_net_old=()                # array of previous network values
    local arr_net=()                    # array of network down bytes, up bytes, sys-time (ms)
    # commands
    local cmd_network=                  # network info handler command
    # individual blocks
    local block_net_down=               # network down speed block
    local block_net_ip=                 # network ip address block
    local block_net_up=                 # network up speed block
    local block_separator_lg=           # large separator block
    local block_separator_sm=           # small separator block
    local block_spacer=                 # spacer block
    local block_final=                  # final block
    # icon blocks
    local block_icon_arch=              # arch icon block
    local block_icon_cpu=               # cpu icon block
    local block_icon_date=              # calendar icon block
    local block_icon_dropbox=           # dropbox icon block
    local block_icon_hhd=               # hhd icon block
    local block_icon_home=              # home icon block
    local block_icon_mem=               # memory icon block
    local block_icon_net_down=          # down arrow icon block
    local block_icon_net_ip=            # globe icon block
    local block_icon_net_up=            # up arrow icon block
    local block_icon_network=           # network icon block
    local block_icon_power=             # power icon block
    local block_icon_temp=              # shield icon block
    local block_icon_time=              # clock icon block
    local block_icon_usb=               # usb icon block
    # block sets
    local blocks_cpu_mem=               # cpu and memory blocks    
    local blocks_date_time=             # date and time blocks
    local blocks_filesystem=            # file system blocks
    local blocks_network=               # network blocks
    local blocks_battery=               # battery blocks
    # colors
    local clr_bad=                      # color bad
    local clr_colon=                    # color colon
    local clr_field=                    # color field
    local clr_good=                     # color good
    local clr_icon=                     # color icon
    local clr_separator=                # color separator
    local clr_slash=                    # color slash
    local clr_warning=                  # color bad
    # integers
    local int_cpu_temp=                 # cpu temp
    local int_fs_total=                 # file system total (bytes)
    local int_fs_used=                  # file system used (bytes)
    local int_mem_total=                # total memory installed (bytes)
    local int_mem_used=                 # memory used (bytes)
    local int_net_down=                 # network download speed (bytes/sec)
    local int_net_up=                   # network upload speed (bytes/sec)
    local int_spacer=                   # width of spacer (px)
    local int_battery_percent=          # battery remaining percent
    # json code snippets
    local json_block_end=               # json code for ending a block
    local json_block_start=             # json code for starting a block
    local json_colon=                   # json code for :
    local json_slash=                   # json code for /
    # overridden shell variables
    local S_COLORS="never"              # turn off mpstat colors
    # cycle counters
    local cnt_fs_cycle=                 # counter for file system info
    local cnt_fs_cycle_max=             # cycles for file system info repeat
    local cnt_net_cycle=                # counter for network info
    local cnt_net_cycle_max=            # cycles for network info repeat
    local cnt_net_ip_cycle=             # inner cycles of network info
    local cnt_net_ip_cycle_max=         # inner cycles of network info for network_ip repeat
    # strings 
    local str_cpu_load=                 # cpu load percent
    local str_date=                     # date
    local str_fs_temp=                  # [temp variable]
    local str_ip_address=               # ip address
    local str_mem_total=                # total memory installed
    local str_mem_used=                 # memory used
    local str_net_down=                 # network down speed
    local str_net_interface=            # network interface name
    local str_net_name=                 # network name
    local str_net_name_old=             # network name at time a
    local str_net_up=                   # network up speed
    local str_temp=                     # cpu temp
    local str_time=                     # time
    local str_battery_percent=          # battery remaining percent
    
    
    local flg_battery=
    local str_net_mode=
    local clr_fs_tmp=
    local clr_cpu_temp=
    local int_cpu_temp_good=
    local int_cpu_temp_warn=
    local int_cpu_temp_bad=
    local clr_cpu_load=
    local clr_mem=
    

    # set defaults
    set_defaults

    # make constants
    mk_json_constant
    mk_blocks_constant

    # start i3-bar infinite loop
    i3bar_loop
    
    exit 0
}


##==================================  MAKE CONSTANTS  ==================================##
# make constant json snippets
mk_json_constant() {
    json_block_end="\"},\n"
    json_block_start="{\"markup\":\"pango\",\"separator\":false,\"separator_block_width\":3" 
    json_colon="<span color='${clr_colon}' font_weight='bold'>:</span>"
    json_slash="<span color='${clr_slash}' font_weight='bold'>/</span>"   
}

# make constant blocks
mk_blocks_constant() {
    block_final="{\"markup\":\"pango\",\"full_text\":\"<span color='${clr_separator}'>"
    block_final+="┃</span>\",\"separator\":false,\"separator_block_width\":0}\n"
    block_icon_arch="`mk_block_icon B ${clr_icon} OpenLogos`"
    block_icon_cpu="`mk_block_icon `"
    block_icon_date="`mk_block_icon `"
    block_icon_dropbox="`mk_block_icon `"
    block_icon_hhd="`mk_block_icon `"
    block_icon_home="`mk_block_icon `"
    block_icon_mem="`mk_block_icon `"
    block_icon_net_down="`mk_block_icon `"
    block_icon_net_ip="`mk_block_icon `"
    block_icon_net_up="`mk_block_icon `"
    block_icon_network="`mk_block_icon `"
    block_icon_power="`mk_block_icon `"
    block_icon_temp="`mk_block_icon `"
    block_icon_time="`mk_block_icon `"
    block_icon_usb="`mk_block_icon `"
    block_separator_lg="{\"markup\":\"pango\",\"full_text\":\"<span color='${clr_separator}'>"
    block_separator_lg+="┃</span>\",\"separator\":false,\"separator_block_width\":3},\n"
    block_separator_sm="{\"markup\":\"pango\",\"full_text\":\"<span color='${clr_separator}'>"
    block_separator_sm+="│</span>\",\"separator\":false,\"separator_block_width\":3},\n"
    block_spacer="{\"separator\":false,\"separator_block_width\":0,\"min_width\":${int_spacer}"
    block_spacer+=",\"full_text\":\" \"},\n"
}


##====================================  MAIN LOOP  =====================================##
i3bar_loop() {
    # set all counters to max
    cnt_battery_cycle=${cnt_battery_cycle_max}
    cnt_fs_cycle=${cnt_fs_cycle_max}
    cnt_net_cycle=${cnt_net_cycle_max}
    # initial total memory reading
    arr_mem=( `free -b | tail -2 | head -1` )
    int_mem_total="${arr_mem[1]}"
    str_mem_total="`int_round ${int_mem_total} 0`"
    # initial network state
    str_net_name_old="initial_blank_name"
    # initial network total bytes down, total bytes up, and system time (ms)
    arr_net_old=( `cat "/sys/class/net/${str_net_interface}/statistics/rx_bytes" \
        "/sys/class/net/${str_net_interface}/statistics/tx_bytes"` `date +%s%N | cut -c1-13` )
    
    # let i3bar know input is in json
    echo '{"version":1}'
    # initialize array stream
    echo '['
    echo '[],'
    
    # main loop repeats every ~2 seconds
    while :
    do
        # file system info
        #if [ ${cnt_fs_cycle} -ge ${cnt_fs_cycle_max} ]; then
            #mk_blocks_filesystem
            #cnt_fs_cycle=0
        #fi
        #((cnt_fs_cycle++))
        
        # network info
        if [ ${cnt_net_cycle} -ge ${cnt_net_cycle_max} ]; then
            mk_block_net_ip
            cnt_net_cycle=0
        fi
        ((cnt_net_cycle++))
        
        mk_blocks_cpu_mem    # ~2 second delay
        mk_blocks_network
        mk_blocks_date_time

        # begin array element
        printf "[\n"
        # print blocks
        printf "${blocks_network}"
        #printf "${block_spacer}"
        #printf "${blocks_filesystem}"
        printf "${block_spacer}"
        printf "${blocks_cpu_mem}"
        printf "${block_spacer}"
        printf "${blocks_date_time}"
        # close array element
        printf "],\n"
    done
}


##===============================  MAKE BLOCK FUNCTIONS  ===============================##
# make json text to include inside a block started by mk_block_start
#   $1=[string] - text
#   $2=[color] (default=${clr_good})
#   $3=[normal,bold,heavy] (default=normal)
mk_json_text() {
    printf "<span color='${2:-${clr_good}}'"
    if [ -n "$3" ]; then
        printf ",\"font_weight\":\"$3\""
    fi
    printf ">%s</span>" "$1"
}

# make generic text block start
#   $1=[string] - string of the same length as minimum block width (default=[none])
#   $2=[left|center|right] - text alignment in block (default=center)
mk_block_start() {
    printf "${json_block_start}"
    if [ -n "$1" ]; then
        printf ",\"min_width\":\"$1\",\"align\":\"${2:-center}\""
    fi
    printf ",\"full_text\":\""
}

# make icon block
#   $1=[icon]
#   $2=[color] (default=${clr_icon})
#   $3=[font] (default=FontAwesome)
mk_block_icon() {
    printf "{\"markup\":\"pango\",\"separator\":false,\"separator_block_width\":0"
    printf ",\"full_text\":\"<span font=\'${3:-FontAwesome}\' "
    printf "color=\'${clr_field:-$2}\'>$1</span>${json_colon}%s" "${json_block_end}"
}


##=====================================  NETWORK  ======================================##
# make IP/internet connection block
mk_block_net_ip() {
    ping -q -c 1 -W 3 google.com &> /dev/null
    if [ $? -ne 0 ]; then
        str_ip_address="offline"
    # do if internet connection is online
    else
        # get IP address from icanhazip.com
        str_ip_address="`curl -s icanhazip.com`"
    fi
    block_net_ip="${block_icon_net_ip}`mk_block_start`"
    if [[ "${str_ip_address}" == "offline" ]]; then
        block_net_ip+="`mk_json_text offline ${clr_bad}`"
    else
        block_net_ip+="`mk_json_text ${str_ip_address}`"
    fi
    block_net_ip+="${json_block_end}"
}

# make network speed blocks
mk_blocks_network() {
    # network total bytes down, total bytes up, and system time (ms)
    arr_net=( `cat "/sys/class/net/${str_net_interface}/statistics/rx_bytes" \
        "/sys/class/net/${str_net_interface}/statistics/tx_bytes"` `date +%s%N | cut -c1-13` )
    # calculate down and up speeds in bytes/sec (workaround because bash can only multiply integers)
    int_net_down=$(( (${arr_net[0]}-${arr_net_old[0]})*1000/(${arr_net[2]}-${arr_net_old[2]}) ))
    int_net_up=$(( (${arr_net[1]}-${arr_net_old[1]})*1000/(${arr_net[2]}-${arr_net_old[2]}) ))
    # reset network speed interval
    arr_net_old=( ${arr_net[*]} )
    str_net_down="`int_round ${int_net_down}`B/s"
    str_net_up="`int_round ${int_net_up}`B/s"
    clr_net_down="`calc_color_percent ${int_net_down} 500000 8000000 20000000`"
    clr_net_up="`calc_color_percent ${int_net_up} 50000 500000 2000000`"
    # make blocks
    block_net_down="${block_icon_net_down}"
    block_net_down+="`mk_block_start x.xxXB/s right; mk_json_text ${str_net_down} "${clr_net_down}"`"
    block_net_down+="${json_block_end}"
    block_net_up="${block_icon_net_up}"
    block_net_up+="`mk_block_start x.xxXB/s right; mk_json_text "${str_net_up}" "${clr_net_up}"`"
    block_net_up+="${json_block_end}"
    blocks_network="${block_separator_lg}${block_net_ip}${block_separator_sm}"
    blocks_network+="${block_net_down}${block_separator_sm}${block_net_up}${block_separator_lg}"
}


##====================================  FILE SYSTEM  ===================================##
# make file system blocks
mk_blocks_filesystem() {
    # file system info array: details on mounted file systems (other that /boot)
    arr_fs=( `df -B 1 --output=source,target,used,size | grep --color=never ^/dev | grep -v /boot` )
    # dropbox info
    arr_fs+=( "[none]" "/Dropbox" "`du -B 1 -s /home/magyar/Dropbox/ | cut -f1`" "2000000000" )
    # parse file system array and build blocks
    blocks_filesystem="${block_separator_lg}"
    local i=0            
    while [ -n "${arr_fs[$i]}" ]; do
        str_fs_tmp="/${arr_fs[$((i+1))]##*/}"
        # add icon blocks
        case ${str_fs_tmp} in
            /Dropbox)     blocks_filesystem+="${block_icon_dropbox}" ;;
            /ntfs-2TB)    blocks_filesystem+="${block_icon_hhd}" ;;
            /home)        blocks_filesystem+="${block_icon_home}" ;;
            /)            blocks_filesystem+="${block_icon_arch}" ;;
            *)            blocks_filesystem+="${block_icon_usb}" ;;
        esac
        int_fs_used="${arr_fs[$((i+2))]}"
        int_fs_total="${arr_fs[$((i+3))]}"
        clr_fs_tmp="`calc_color_percent $(( ${int_fs_used}*100/${int_fs_total} ))`"
        str_fs_used="`int_round ${int_fs_used}`"
        str_fs_total="`int_round ${int_fs_total}`"
        blocks_filesystem+="`mk_block_start x.xxA/x.xxA`"
        blocks_filesystem+="`mk_json_text ${str_fs_used} "${clr_fs_tmp}"`${json_slash}"
        blocks_filesystem+="`mk_json_text ${str_fs_total} "${clr_fs_tmp}"`${json_block_end}"        
        if [ -n "${arr_fs[$((i+5))]}" ]; then
            blocks_filesystem+="${block_separator_sm}"
        fi
        i=$((i+4))
    done
    blocks_filesystem+="${block_separator_lg}"
}


##===================================  CPU AND MEMORY  =================================##
# make CPU load, CPU temp, and memory blocks
mk_blocks_cpu_mem() {
    # cpu load from mpstat with a 1 second interval taken twice
    str_cpu_idle="`mpstat 1 2 | tail -2 | head -1`"
    str_cpu_idle="${str_cpu_idle##* }"
    str_cpu_load="`echo "scale=1; (100 - ${str_cpu_idle}+0.05)/1" | bc`"
    # parse percent
    if [[ "${str_cpu_load}" == "0" ]]; then
        str_cpu_load="0.0"
    elif [ ${#str_cpu_load} -eq 2 ]; then
        str_cpu_load="0${str_cpu_load}"
    elif [ ${#str_cpu_load} -eq 4 ]; then
        str_cpu_load="${str_cpu_load:0:2}"
    elif [ ${#str_cpu_load} -eq 5 ]; then
        str_cpu_load="100"
    fi
    clr_cpu_load="`calc_color_percent "${str_cpu_load%.*}"`"
    str_cpu_load+='%%'
    # cpu temp from sensors
    int_cpu_temp=`sensors | grep --color=never -oP 'Core(.*?)\+\K[0-9]+(?=\.)'`
    str_cpu_temp="${int_cpu_temp}°C"
    clr_cpu_temp="`calc_color_percent ${int_cpu_temp} ${int_cpu_temp_good} ${int_cpu_temp_warn} \
                  ${int_cpu_temp_bad}`"
    
    # call free to get memory info
    arr_mem=( `free -b | tail -2 | head -1` )
    int_mem_used="${arr_mem[2]}"
    str_mem_used="`int_round ${int_mem_used}`"
    clr_mem="`calc_color_percent $(( ${int_mem_used}*100/${int_mem_total} ))`"
    # make blocks
    blocks_cpu_mem="${block_separator_lg}"
    blocks_cpu_mem+="${block_icon_cpu}"
    blocks_cpu_mem+="`mk_block_start xxxp; mk_json_text "${str_cpu_load}" "${clr_cpu_load}"`"
    blocks_cpu_mem+="${json_block_end}${block_separator_sm}"
    blocks_cpu_mem+="${block_icon_temp}"
    blocks_cpu_mem+="`mk_block_start xxDC; mk_json_text ${str_cpu_temp} ${clr_cpu_temp}`"
    blocks_cpu_mem+="${json_block_end}${block_separator_sm}"
    blocks_cpu_mem+="${block_icon_mem}"
    blocks_cpu_mem+="`mk_block_start xx.xA/x.xxA; mk_json_text "${str_mem_used}" "${clr_mem}"`"
    blocks_cpu_mem+="${json_slash}`mk_json_text "${str_mem_total}" "${clr_mem}"`${json_block_end}"
    blocks_cpu_mem+="${block_separator_lg}"
}


##===================================  DATE AND TIME  ==================================##
# make date and time blocks
mk_blocks_date_time() {
    str_time="`date "+%H:%M %D"`"
    str_date="${str_time#* }"
    str_time="${str_time% *}"
    blocks_date_time="${block_separator_lg}"
    blocks_date_time+="${block_icon_date}"
    blocks_date_time+="`mk_block_start xx/xx/xx; mk_json_text "${str_date}"`${json_block_end}"
    blocks_date_time+="${block_separator_sm}"
    blocks_date_time+="${block_icon_time}"
    blocks_date_time+="`mk_block_start xx.xx; mk_json_text "${str_time}"`${json_block_end}"
    blocks_date_time+="${block_final}"
}


##==================================  OTHER FUNCTIONS  =================================##
# output hex color code (green-->yellow-->red) based on integer inputs
#   $1=[input integer]
#   $2=[integer good] (default=45)
#   $3=[integer warn] (default=70)
#   $4=[integer bad] (default=95)
calc_color_percent() {
    local int_in=$1
    local int_bad="${4:-90}"            # int where color is completely red    = #FF0000
    local int_warn="${3:-50}"           # int where color is completely yellow = #FFFF00
    local int_good="${2:-10}"           # int where color is completely green  = #00FF00
    local int_red=
    local int_green=
    # invert values if $int_good is greater than $int_bad
    if [ ${int_good} -gt ${int_bad} ]; then
        int_in="-${int_in}"
        int_good="-${int_good}"
        int_warn="-${int_warn}"
        int_bad="-${int_bad}"
    fi
    # calculate red and green values
    if [ ${int_in} -ge ${int_bad} ]; then
        int_red="0xFF"
        int_green="0x00"
    elif [ ${int_in} -le ${int_good} ]; then
        int_red="0x00"
        int_green="0xFF"
    elif [ ${int_in} -le ${int_warn} ]; then
        int_green="0xFF"
        int_red="$(( (${int_in}-${int_good})*255/(${int_warn}-${int_good}) ))"
    else
        int_green="$(( (${int_bad}-${int_in})*255/(${int_bad}-${int_warn}) ))"
        int_red="0xFF"
    fi
    # output hex color #XXXXXX
    printf "%s%02X%02X%02X\n" "#" "${int_red}" "${int_green}" "00"
}


# round an integer input to 4-5 characters with the proper metric prefix (K,M,G,T,P,E)
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


main
