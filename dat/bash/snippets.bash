#!/bin/bash
## snippets.bash ::

print_help() {
cat <<'HELPDOC'
NAME
    snippets.bash

SYNOPSIS
    . snippets.bash
    bash snippets.bash

DESCRIPTION
    Basically just a bunch of bash examples.
HELPDOC
}

if [ "$0" != "$BASH_SOURCE" ]; then
    printf 'sourcing snippets.bash\n'
else
    printf 'running snippets.bash\n'
fi

## script variables ::
file_script="$(basename "$BASH_SOURCE")"
dir_script="$(cd "$(dirname "$BASH_SOURCE")" && pwd)"
path_script="$(realpath "$BASH_SOURCE")"
pid_script="$$"

## signals, trap ::
# EXIT catches any sort of exit except `kill -9`:
#trap <cleanup_function> EXIT

# INT catches <c-c>:
#trap "printf 'ctrl-c was pressed, but I ain't gonna exit\n'" INT

# USR1, USR2 can caught to execute commands:
#trap "printf 'USR1 signal received\n'" USR1
#trap <some_function> USR2

## terminal codes ::
clear_line=$'\033[2K'
clear_to_beginning_of_line=$'\033[1K'

# color:
bold=$'\e[1m'
reset=$'\e[0m'

# color: 38;5;XXm sets foreground, 48;5;XX;m sets background:
black=$'\e[38;5;0m'
red=$'\e[38;5;1m'
green=$'\e[38;5;2m'
yellow=$'\e[38;5;3m'
blue=$'\e[38;5;4m'
magenta=$'\e[38;5;5m'
cyan=$'\e[38;5;6m'
white=$'\e[38;5;7m'
gray=$'\e[38;5;8m'
red1=$'\e[38;5;9m'
green1=$'\e[38;5;10m'
yellow1=$'\e[38;5;11m'
blue1=$'\e[38;5;12m'
magenta1=$'\e[38;5;13m'
cyan1=$'\e[38;5;14m'
white1=$'\e[38;5;15m'

# Most graphical terminal emulators have access to 256 or more colors. Many
# allow customizing at least some (16) of them through config files, etc.
# Colors can also sometimes be dynamically set.
# Set color 69 to #442200:
#   $ echo -en '\e]4;69;#442200\e\\'
# Set terminal background to #ffaacc:
#   $ echo -en '\e]11;#ffaacc\e\\'

# blocks: █ ▌ ▐ ▄ ▀ :
block=$'\u2588'
block_l=$'\258c'
block_r=$'\2590'
block_b=$'\u2584'
block_t=$'\u2580'

# bars: ─ │ ┌ ┐ └ ┘ ┤ ├ ┴ ┬ ┼ :
bar_h=$'\u2500'
bar_v=$'\u2502'
bar_tl=$'\u250c'
bar_tr=$'\u2510'
bar_bl=$'\u2514'
bar_br=$'\u2518'
bar_vl=$'\u2524'
bar_vr=$'\u251c'
bar_ht=$'\u2534'
bar_hb=$'\u252c'
bar_x=$'\u253c'

## messages ::
msg() {
    [ "$flg_quiet" = 'true' ] && return
    printf "\e[1;38;5;12m==> \e[0;38;5;15m$1\e[0m\n" "${@:2}"
}

msg_ask() {
    printf "\e[1;38;5;10m::> \e[0;38;5;15m$1\e[0m " "${@:2}"
}

msg_error() {
    printf "\e[1;38;5;9mE: \e[0;38;5;15m$1\e[0m\n" "${@:2}" >&2
}

msg_warn() {
    printf "\e[1;38;5;11mW: \e[0;38;5;15m$1\e[0m\n" "${@:2}" >&2
}

msg_cmd() {
    local arg str=$'\e[1;38;5;10m'' -$'$'\e[0;38;5;15m'
    if [ $EUID -eq 0 ]; then
        str=$'\e[1;38;5;9m'' -#'$'\e[0;38;5;15m'
    fi
    for arg in "$@"; do
        str+=" $(printf '%q' "$arg")"
    done
    printf '%s\e[0m\n' "$str"
}

msg2() {
    [ "$flg_quiet" = 'true' ] && return
    printf "\e[1;38;5;12m -> \e[0;38;5;15m$1\e[0m\n" "${@:2}"
}

msg2_error() {
    printf "\e[1;38;5;9m -> \e[0;38;5;15m$1\e[0m\n" "${@:2}" >&2
}

msg2_warn() {
    printf "\e[1;38;5;11m -> \e[0;38;5;15m$1\e[0m\n" "${@:2}" >&2
}

## sed ::
# print all lines after BEGIN inclusively:
#sed -n '/BEGIN/,$p'

# print all lines after BEGIN non inclusively:
#sed '0,/BEGIN/d'

# print all lines before END inclusively:
#sed '/END/q'

# print all lines before END non inclusively:
#sed '/END/Q'

# print lines between BEGIN and END inclusively:
#sed -n '/START/,/END/p'

# print lines between BEGIN and END non inclusively:
#sed -n '/START/,/END/{//!p}'

## grep ::
# find non ascii characters:
#grep -P '[^\x09\x0a\x0d -~]' <FILE>

## parse args ::
args=()
flg_a=false
opt_x=
n_args=0
n_flgs=0
n_opts=0
args_parse() {
    local _args=("$@") a=0 arg="${_args[a]}" error_opt error_unknown
    error_opt() {
        msg_error '%s requires an option' "$arg"
        exit 2
    }
    error_unknown() {
        msg_error 'unknown argument: %s' "${arg:2:1}"
        exit 2
    }
    while [ -n "$arg" ]; do case "$arg" in
        # flags:
        -A|--A-long)
            flg_a=true
            ((n_flgs++)); arg="${_args[((++a))]}" ;;
        # options:
        -x|--x-long)
            opt_x="${_args[((++a))]}"
            [ $# -le $a ] && error_opt
            ((n_opts++)); arg="${_args[((++a))]}" ;;
        # help:
        -H|--help)
            if [ "$(type -t print_help)" = 'function' ]; then
                print_help
            else
                msg 'no help info'
            fi
            exit 0 ;;
        # all flags:
        -[AH]*)
            # all flags and options:
            [[ ! "${arg:2:1}" =~ [ABxyH] ]] && error_unknown
            _args[((a--))]="-${arg:2}"
            arg="${arg:0:2}" ;;
        # all options:
        -[x]*)
            _args[$a]="${arg:2}"
            arg="${arg:0:2}"
            ((a--)) ;;
        # start args:
        --)
            ((a++))
            break ;;
        *)
            break ;;
    esac; done
    # get args:
    args=("${_args[@]:a}")
    n_args=${#args[@]}
}

## PATH, bin, command ::
path_add() {
    # add $1 to the end of PATH unless it is already in PATH:
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            export PATH="$1${PATH:+:$PATH}" ;;
    esac
}

is_bin() (
    # posix compatible way to check if $1 is an executable somewhere in $PATH:
    [ -z "$1" ] && return 1
    IFS=':'
    for dir in $PATH; do
        [ -f "$dir/$1" ] && [ -x "$dir/$1" ] && return 0
    done
    return 1
)
# Why?
# `which` is not posix and may have differing implementations. `command -v/-V
# CMD` returns true if there is a shell function CMD even if no executable CMD
# exists within $PATH.

is_command() {
    command -v "$1" &>/dev/null
}

is_function() {
    [ "$(type -t "$1")" = 'function' ]
}

## status checks ::
is_root() {
    [ $(id -u) -eq 0 ] && return 0
    return 1
}

status_internet() {
    ping -q -c1 -W2 google.com &>/dev/null || \
        ping -q -c1 -W2 archlinux.org &>/dev/null || \
        ping -q -c1 -W4 google.com &>/dev/null
}

status_ntp() {
    timedatectl | grep -q 'clock synchronized: yes'
}

status_tor() {
    if [ ! -f /usr/bin/torsocks ] || { ! status_internet ;}; then
        return 1
    fi
    torsocks curl -Im4 google.com &>/dev/null || \
        torsocks curl -Im6 archlinux.org &>/dev/null || \
        torsocks curl -Im8 google.com &>/dev/null
}

status_xorg() {
    [ -n "$DISPLAY" ] || xset q &>/dev/null
}

## ip/mac ::
address_ip() {
    if { status_internet ;}; then
        curl -s -m 4 api.ipify.org || curl -s -m 4 icanhazip.com
    else
        printf 'n/a\n'
        return 1
    fi
}

address_mac() {
    ip link show "$(ip link | \
        grep -Pom1 '^[0-9]+: \K[^:]+(?=: <BROADCAST)')" | \
        grep -Po 'link/ether \K[^ ]+(?= )'
}

## images ::
is_img() {
    identify "$1" &>/dev/null
}

img_size() {
    if { identify "$@" &>/dev/null ;}; then
        identify -format '%wx%h\n' "$@"
    else
        return 1
    fi
}

img_size_set() {
    # set $img_w and $img_h from image $1:
    if { identify "$1" &>/dev/null ;}; then
        img_w="$(identify -format '%w %h' "$1")"
        img_h="${img_w#* }"
        img_w="${img_w% *}"
    else
        img_w=0
        img_h=0
        return 1
    fi
}

## arrays, strings, numbers ::
arr_contains() {
    # check if array var $1 contains $2:
    local arr e
    eval "arr=(\"\${$1[@]}\")"
    for e in "${arr[@]}"; do
        [ "$2" = "$e" ] && return 0
    done
    return 1
}

is_float() {
    [[ "$1" =~ ^-?[1-9][0-9]*(\.[0-9]*)?$ ]]
}


is_int() {
    [[ "$1" =~ ^-?[1-9][0-9]*$ ]]
}

is_time() {
    [[ "$1" =~ ^[1-9][0-9]*(\.[0-9]*)?$ ]] || \
        [[ "$1" =~ ^([0-9]+:)?([0-5][0-9]:)?[0-5][0-9](\.[0-9]*)?$ ]]
}

## conversions ::
to_secs() {
    is_time "$1" && sed -E \
        's/(.*):(.+):(.+)/\1*3600+\2*60+\3/;s/(.+):(.+)/\1*60+\2/' \
        <<<"$1" | bc
}

chr() {
    if ! [[ "$1" =~ ^[0-9]+$ ]] || [ "$1" -ge 256 ]; then
        return 1
    fi
    printf "\\$(printf '%03o' "$1")\n"
}

ord() {
    if ! [[ "$1" =~ ^.$ ]]; then
        return 1
    fi
    LC_CTYPE=C printf "%d\n" "'$1"
}

## filenames ::
file_base() {
    printf '%s' "${1##*/}"
}

file_dir() {
    printf '%s' "$(cd "$(dirname "$1")" && pwd)"
}

file_ext() {
    local base="${1##*/}"
    local ext="${base#*.}"
    [ "$base" = ".$ext" ] && ext=''
    printf '%s' "$ext"
}

## wget ::
wget_file() {
    local url="$1"
    local url_file="$2"
    local n_tries=16
    local n=0
    local c=1
    if [ -z "$2" ]; then
        url_file="${url##*/}"
        url_file="${url_file%%\?*}"
    fi
    if [ -f "$url_file" ]; then
        while [ -f "${url_file}_$c" ]; do
            ((c++))
        done
        url_file="${url_file}_$c"
    fi
    while [ $n -lt $n_tries ] && [ ! -f "$url_file" ]; do
        wget -q -U 'Mozilla' --timeout=8 --waitretry=$n_tries \
            --tries=$n_tries --retry-connrefused -O "$url_file" "$url"
        sleep $n
        ((n++))
    done
    if [ -f "$url_file" ]; then
        return 0
    else
        return 1
    fi
}

wget_html() {
    local url="$1"
    local n_tries=16
    local n=0
    local html=
    while [ $n -lt $n_tries ] && [ ! -n "$html" ]; do
        html=$(wget -q -U 'Mozilla' --timeout=8 --waitretry=$n_tries \
            --tries=$n_tries --retry-connrefused -O - "$url")
        sleep $n
        ((n++))
    done
    if [ -n "$html" ]; then
        printf '%s\n' "$html"
        return 0
    else
        return 1
    fi
}

# vim:ft=bash