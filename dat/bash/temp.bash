#!/bin/bash
## temp.bash ::
# shellcheck disable=SC2034

print_help() { cat <<'HELPDOC'
NAME
    temp.bash - bash script template

SYNOPSIS
    temp.bash [option...] [arg...]

DESCRIPTION
    Bash example/template script. Prints input arguments.

OPTIONS
    -r, --remote <host>     Set remote hostname. (default: localhost)
    -Q, --quiet             Do not write anything to standard output.
    -V, --verbose           Print verbose information.
    --nocolor               Disable colored output.
    -H, --help              Print help.

ENVIRONMENT
    NOCOLOR=1   Disable colored output.
    QUIET=1     Run silently
    VERBOSE=1   Run verbosely.
HELPDOC
}
[[ $0 != "${BASH_SOURCE[0]}" ]] && { print_help; return 0 ;}
[[ $1 =~ ^(-H|--help)$ ]] && { print_help; exit ;}

## settings ::
readonly -a deps=()
readonly -a opts=(-r: --remote: -Q --quiet -V --verbose --nocolor -H --help)
DEBUG="${DEBUG:-0}"
NOCOLOR="${NOCOLOR:-0}"
QUIET="${QUIET:-0}"
VERBOSE="${VERBOSE:-0}"
remote='localhost'

## internal functions/variables ::
readonly -a args=("$@")
args_operands=() args_options=() args_parsed=()
readonly script="$(realpath "$BASH_SOURCE")"
host="$HOSTNAME"

# colors:
blue=$'\e[38;5;12m'
bold=$'\e[1m'
cyan=$'\e[38;5;14m'
green=$'\e[38;5;10m'
grey=$'\e[38;5;8m'
magenta=$'\e[38;5;13m'
off=$'\e[0m'
red=$'\e[38;5;9m'
white=$'\e[38;5;15m'
yellow=$'\e[38;5;11m'
clear_colors() { unset blue bold cyan green grey magenta off red white yellow ;}

# messages:
msg() { ((QUIET)) || printf "$bold$blue=> $off$white$*$off\n" ;}
msg2() { ((QUIET)) || printf "$bold$blue > $off$white$*$off\n" ;}
msg_debug() { ((DEBUG)) && printf "${yellow}D: $off$*\n" >&2 ;}
msg_error() { printf "$bold${red}E: $off$white$*$off\n" >&2 ;}
msg_good() { ((QUIET)) || printf "$bold$green=> $off$white$*$off\n" ;}
msg_plain() { ((QUIET)) || printf "$off$white   $*$off\n" ;}
msg_warn() { printf "$bold${yellow}W: $off$white$*$off\n" >&2 ;}
msg_cmd() {
    ((QUIET)) && return
    [[ $EUID -eq 0 ]] && printf "$bold$red #" || printf "$bold$blue $"
    printf "$off$white"; "$cmd_printf" ' %q' "$@"; printf "$off\n"
}

# errors:
error() { msg_error "$*"; exit 3 ;}

# tests:
is_cmd() { command -v "$1" &>/dev/null ;}
is_img() { [[ -f $1 ]] && identify "$1" &>/dev/null ;}
is_port() { [[ $1 =~ ^[1-9][0-9]*$ && $1 -lt 65536 ]] ;}

# commands:
cmd_printf='printf'
[[ -f /usr/bin/printf ]] && cmd_printf='/usr/bin/printf'
exec_cmd() { ((VERBOSE)) && msg_cmd "$@"; "$@" ;}

# arg parser:
# Separate combined options, return nonzero if error.
# Parse args and opts; set args_operands and args_options:
#   args=("$@")
#   opts=(-f --for -b: --bar: help)
#   parse_args || exit
#   set -- "${args_options[@]}"
#   while [[ -n $1 ]]; do case "$1" in ... esac; shift; done
parse_args() {
    local a=0 opt= sflgs= sopts= arg="${args[0]}"
    local -a lflgs=() lopts=()
    bad_opt() { msg_error "unrecognized option: -${arg:2:1}" ;}
    bad_optarg() { msg_error "option requires an argument: $arg" ;}
    bad_flg() { msg_error "option does not take argument: ${arg%%=*}" ;}
    for opt in "${opts[@]}"; do case "$opt" in
        -?) sflgs="$sflgs${opt:1}" ;;
        -?:) sopts="$sopts${opt:1:1}" ;;
        *:) lopts+=("${opt:0:-1}") ;;
        *) lflgs+=("$opt") ;;
    esac; done
    while [[ -n $arg ]]; do case "$arg" in
        --) ((a++)); break ;;
        -[$sflgs]) args_options+=("$arg") ;;
        -[$sflgs]*) [[ ! $sflgs$sopts =~ ${arg:2:1} ]] && { bad_opt; return 3 ;}
            args_options+=("${arg:0:2}"); arg="-${arg:2}"; continue ;;
        -[$sopts]) [[ $((${#args[@]}-a)) -le 1 ]] && { bad_optarg; return 3 ;}
            args_options+=("$arg" "${args[((++a))]}") ;;
        -[$sopts]*) args_options+=("${arg:0:2}" "${arg:2}") ;;
        *=*) [[ " ${lflgs[*]} " =~ " ${arg%%=*} " ]] && { bad_flg; return 3 ;}
            [[ " ${lopts[*]} " =~ " ${arg%%=*} " ]] || break
            args_options+=("${arg%%=*}" "${arg#*=}") ;;
        *) if [[ " ${lflgs[*]} " =~ " $arg " ]]; then
                args_options+=("$arg")
            elif [[ " ${lopts[*]} " =~ " $arg " ]]; then
                [[ ${#args[@]} -le $((a+1)) ]] && { bad_optarg; return 3 ;}
                args_options+=("$arg" "${args[((++a))]}")
            else break; fi ;;
    esac; arg="${args[((++a))]}"; done
    args_operands=("${args[@]:a}")
}

## main ::
trap exit INT
((NOCOLOR)) || ! [[ -t 1 && -t 2 ]] && clear_colors

# parse args:
parse_args || exit
set -- "${args_options[@]}"
while [[ -n $1 ]]; do case "$1" in
    -r|--remote) shift; remote="$1" ;;
    -Q|--quiet) QUIET=1; VERBOSE=0 ;;
    -V|--verbose) QUIET=0; VERBOSE=1 ;;
    --nocolor) clear_colors ;;
    -H|--help) print_help; exit 0 ;;
esac; shift; done
msg_debug "options=(${args_options[*]})"
msg_debug "operands=(${args_operands[*]})"

# errors:
for d in "${deps[@]}"; do is_cmd "$d" || error "missing dependency: $d"; done

# vim:ft=bash
