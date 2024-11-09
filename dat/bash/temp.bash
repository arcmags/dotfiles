#!/bin/bash
## temp.bash ::

print_help() { cat <<'HELPDOC'
NAME
    temp.bash - print args

SYNOPSIS
    temp.bash [option...] [arg...]

DESCRIPTION
    Bash example/template script. Prints input arguments.

OPTIONS
    -r, --remote <host>
        Set remote hostname. (default: localhost)

    -Q, --quiet
        Do not write anything to standard output.

    -V, --verbose
        Print verbose information.

    --nocolor
        Disable colored output.

    -H, --help
        Print help.
HELPDOC
}; [ "$0" != "$BASH_SOURCE" ] && { print_help; return 0 ;}

## config ::
remote='localhost'
DEBUG="${DEBUG:-0}"
VERBOSE="${VERBOSE:-0}"
NOCOLOR="${NOCOLOR:-0}"
QUIET="${QUIET:-0}"

# args:
opts=(-r: --remote: -D --debug -Q --quiet -V --verbose -H --help --nocolor DEBUG)

# internal:
args=("$@")
deps=()
lhost="$HOSTNAME"
path_script="$(realpath "$BASH_SOURCE")"
pid_script="$$"
script="$(basename "$0")"

## colors ::
blue=$'\e[38;5;12m'
bold=$'\e[1m'
green=$'\e[38;5;10m'
off=$'\e[0m'
red=$'\e[38;5;9m'
white=$'\e[38;5;15m'
yellow=$'\e[38;5;11m'
if tput setaf 0 &>/dev/null; then
    blue="$(tput setaf 12)"
    bold="$(tput bold)"
    green="$(tput setaf 10)"
    off="$(tput sgr0)"
    red="$(tput setaf 9)"
    white="$(tput setaf 15)"
    yellow="$(tput setaf 11)"
fi
clear_colors() { unset blue bold green off red white yellow ;}

## messages ::
# TODO: make these take format strings?
msg() { ((QUIET)) && return; printf "$blue$bold=> $off$white%s$off\n" "$*" ;}
msg2() { ((QUIET)) && return; printf "$blue$bold > $off$white%s$off\n" "$*" ;}
msg_debug() { ((DEBUG)) && printf "$yellow[%d] $off%s\n" $BASH_LINENO "$*" ;}
msg_error() { printf "$red${bold}E: $off$white%s$off\n" "$*" >&2 ;}
msg_warn() { printf "$yellow${bold}W: $off$white%s$off\n" "$*" >&2 ;}
msg_good() { ((QUIET)) &&return;printf "$green$bold=> $off$white%s$off\n" "$*";}
msg_cmd() { [ $EUID -eq 0 ] && printf "$red$bold #" || printf "$blue$bold $"
    printf "$off$white"; printf ' %q' "$@"; printf "$off\n" ;}

## errors ::
error() { msg_error "$@"; exit 5 ;}
error_opt() { error "unrecognized option: $*" ;}
error_optarg() { error "option requires an argument: $*" ;}
error_flg() { error "option does not take argument: $*" ;}

## tests ::
is_cmd() { command -v "$1" &>/dev/null ;}
is_img() { [ -f "$1" ] && identify "$1" &>/dev/null ;}

## commands ::
cmd_exec() { ((verbose)) && msg_cmd "$@"; "$@" ;}
input() { read -erp $'\e[1;38;5;10m''> '$'\e[0;38;5;15m'"$1 "$'\e[0m' "$2" ;}

## arg parser ::
# usage:
#   args=("$@"); opts=(-f --for -b: --bar: help)
#   parse_args
#   set -- "${args_parsed[@]}"
parse_args() {
    args_parsed=()
    local a=0 opt= sflgs= sopts= sflgopts= arg="${args[0]}"
    local -a lflgs=() lopts=()
    for opt in "${opts[@]}"; do case "$opt" in
        -?) sflgs="$sflgs${opt:1}" ;;
        -?:) sopts="$sopts${opt:1:1}" ;;
        *:) lopts+=("${opt:0:((${#opt}-1))}") ;;
        *) lflgs+=("$opt") ;;
    esac; done
    sflgopts="$sflgs$sopts"
    while [ -n "$arg" ]; do
        case "$arg" in
            --) ((a++)); break ;;
            -[$sflgs]*)
                if [ ${#arg} -eq 2 ]; then
                    args_parsed+=("$arg"); arg="${args[((++a))]}"
                else
                    [[ "$sflgopts" =~ "${arg:2:1}" ]] || error_opt "-${arg:2:1}"
                    args_parsed+=("${arg:0:2}"); arg="-${arg:2}"
                fi ;;
            -[$sopts]*)
                if [ ${#arg} -eq 2 ]; then
                    [ $(($#-a)) -le 1 ] && error_optarg "$arg"
                    args_parsed+=("$arg" "${args[((++a))]}")
                else
                    args_parsed+=("${arg:0:2}" "${arg:2}")
                fi
                arg="${args[((++a))]}" ;;
            *=*)
                [[ " ${lflgs[*]} " =~ " ${arg%%=*} " ]] &&error_flg "${arg%%=*}"
                if [[ " ${lopts[*]} " =~ " ${arg%%=*} " ]]; then
                    args_parsed+=("${arg%%=*}" "${arg#*=}")
                else
                    break
                fi
                arg="${args[((++a))]}" ;;
            *)
                if [[ " ${lflgs[*]} " =~ " $arg " ]]; then
                    args_parsed+=("$arg")
                elif [[ " ${lopts[*]} " =~ " $arg " ]]; then
                    [ ${#args[@]} -le $((a+1)) ] && error_optarg "$arg"
                    args_parsed+=("$arg" "${args[((++a))]}")
                else
                    break
                fi
                arg="${args[((++a))]}" ;;
        esac
    done
    args_parsed+=('--' "${args[@]:a}")
}

## main ::
trap exit INT

# clear colors if not connected to terminal:
[ ! -t 1 ] || [ ! -t 2 ] || ((nocolor)) && clear_colors

# parse args:
parse_args
set -- "${args_parsed[@]}"

while [ -n "$1" ]; do case "$1" in
    -r|--remote) shift; remote="$1" ;;
    -D|--debug|DEBUG) DEBUG=1 ;;
    -Q|--quiet) QUIET=1; VERBOSE=0 ;;
    -V|--verbose) QUIET=0; VERBOSE=1 ;;
    --nocolor) clear_colors ;;
    -H|--help) print_help; exit 0 ;;
    --) shift; break ;;
esac; shift; done
msg_debug "${args_parsed[*]}"

# dependency error:
for d in "${deps[@]}"; do is_cmd "$d" || error "missing dependency: $d"; done

#msg "verbose: $verbose"
#msg "quiet: $quiet"
#msg "remote: $remote"
#msg "positional opts:"
#for o in "$@"; do
    #msg2 "$o"
#done

# vim:ft=bash
