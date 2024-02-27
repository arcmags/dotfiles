#!/bin/bash
## temp.bash ::

print_help() {
cat <<'HELPDOC'
NAME
    temp.bash

SYNOPSIS
    temp.bash [-a] [-x OPT] [ARG...]

DESCRIPTION
    Bash template script.

OPTIONS
    -a, --a-long
        Set flag_a = true.

    -x, --x-long OPTION
        Set opt_x = OPTION.

    -H, --help
        Print help.
HELPDOC
}

## internal control ::
file_script="$(basename "$BASH_SOURCE")"
dir_script="$(cd "$(dirname "$BASH_SOURCE")" && pwd)"
path_script="$(realpath "$BASH_SOURCE")"
pid_script="$$"
# args:
args=()
flg_a=false
opt_x=
n_args=0
n_flgs=0
n_opts=0

## signals, trap ::
# EXIT catches any sort of exit except `kill -9`:
#trap <cleanup_function> EXIT

# INT catches <c-c>:
trap "printf 'ctrl-c caught\n'; exit 1" INT

## debug ::
debug() {
    local vars=($(compgen -v | sed '0,/^_$/d' | sort))
    local arr=() val= var=
    for var in "${vars[@]}"; do
        val="${!var}"
        if [[ "$(declare -p "$var")" =~ 'declare -a' ]]; then
            eval "arr=(\"\${$var[@]}\")"
            val=$'\e[38;5;13m''('$'\e[38;5;15m'
            for a in "${arr[@]::${#arr[@]}-1}"; do
                val+=$'\e[38;5;13m'"'"$'\e[38;5;15m'"$a"$'\e[38;5;13m'"' "
            done
            val+=$'\e[38;5;13m'"'"$'\e[38;5;15m'"${arr[-1]}"$'\e[38;5;13m'"'"
            val+=$'\e[38;5;13m'')'$'\e[38;5;15m'
        fi
        printf '\e[0;38;5;12m%s\e[38;5;11m=\e[38;5;15m%s\n' "$var" "$val"
    done
}

## messages ::
msg() {
    [ "$flag_quiet" = 'true' ] && return
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
    local ps1=$'\e[1;38;5;10m'' :$'
    [ $EUID -eq 0 ] && ps1=$'\e[1;38;5;9m'' :#'
    printf '%s \e[0;38;5;15m%s\e[0m\n' "$ps1" "$(printf '%q ' "$@")"
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

# filenames ::
file_set() {
    # set $file_dir, $file_name, $file_base, $file_ext from file $1:
    if [ ! -e "$1" ]; then
        return 1
    fi
    file_dir="$(cd "$(dirname "$1")" && pwd)"
    file_name="$(basename "$1")"
    file_base="${file_name%.*}"
    if [ "${file_name:0:1}" = '.' ]; then
        file_base="${file_name:1}"
        file_base=".${file_base%.*}"
    fi
    file_ext="${file_name:${#file_base}}"
}

## parse args ::
args_parse() {
    local _args=("$@") a=0 arg="${_args[a]}"
    while [ -n "$arg" ]; do case "$arg" in
        # flags:
        -A|--A-long)
            flg_a=true
            ((n_flgs++)); arg="${_args[((++a))]}" ;;
        # options:
        -x|--x-long)
            [ $# -le $((a+1)) ] && msg_error "arg required: $arg" && exit 2
            opt_x="${args[((++a))]}"; ((n_opts++)); arg="${args[((++a))]}" ;;
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
            if [[ ! "${arg:2:1}" =~ [AHx] ]]; then
                msg_error 'unknown option: %s' "${arg:2:1}"
                exit 2
            fi
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

## main() ::
args_parse "$@"
debug

for req in "${requirements[@]}"; do if ! command -v "$req" &>/dev/null; then
    msg_error 'required: %s' "$req"
    #exit 5
fi; done

# vim:ft=bash
