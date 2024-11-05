#!/bin/bash
## temp.bash ::

print_help() { cat <<'HELPDOC'
NAME
    temp.bash - print args

SYNOPSIS
    temp.bash [OPTION...] [ARG...]

DESCRIPTION
    Bash example/template script. Prints input arguments.

OPTIONS
    -r, --remote HOST
        Set remote hostname. (default: localhost)

    -V, --verbose
        Print verbose information.

    -H, --help
        Print help.
HELPDOC
}; [ "$0" != "$BASH_SOURCE" ] && { print_help; return 0 ;}

## variables ::
rhost='localhost'

# args:
arg_flgs='V'
arg_opts='r'
flg_verbose=false
opt_rhost=

# internal:
deps=()
lhost="$HOSTNAME"
path_script="$(realpath "$BASH_SOURCE")"
pid_script="$$"
script="$(basename "$0")"

## functions ::
error() { msg_error "$@"; exit 5 ;}
error_arg() { error "option requires an argument: $*" ;}
error_opt() { error "unrecognized option: $*" ;}
input() { read -erp $'\e[1;38;5;10m''> '$'\e[0;38;5;15m'"$1 "$'\e[0m' "$2" ;}
is_cmd() { command -v "$1" &>/dev/null ;}
is_img() { [ -f "$1" ] && identify "$1" &>/dev/null ;}

# messages:
msg() { printf '\e[1;38;5;12m=> \e[0;38;5;15m%s\e[0m\n' "$*" ;}
msg2() { printf '\e[1;38;5;12m > \e[0;38;5;15m%s\e[0m\n' "$*" ;}
msg_cmd() {
    [ $EUID -eq 0 ] && printf '\e[1;38;5;9m #' || printf '\e[1;38;5;12m $'
    printf ' \e[0;38;5;15m'; for a in "${@:1:1}"; do printf '%q' "$a"; done
    for a in "${@:2}"; do printf ' %q' "$a"; done; printf '\e[0m\n'
}
msg_debug() { printf "[%d] %s\n" $BASH_LINENO "$*" ;}
msg_error() { printf '\e[1;38;5;9mE: \e[0;38;5;15m%s\e[0m\n' "$*" >&2 ;}
msg_good() { printf '\e[1;38;5;10m=> \e[0;38;5;15m%s\e[0m\n' "$*" ;}
msg2_good() { printf '\e[1;38;5;10m > \e[0;38;5;15m%s\e[0m\n' "$*" ;}
msg_to() { msg "$1$(printf ' \e[1;38;5;12m-> \e[0;38;5;15m%s' "${@:2}")" ;}
msg_warn() { printf '\e[1;38;5;11mW: \e[0;38;5;15m%s\e[0m\n' "$*" >&2 ;}

## arg parser ::
a=0 arg="$1" args=("$@") n_args=$# opt= pargs=()
parse_flg() {
    arg="${args[((++a))]}"
}
parse_opt() {
    [ $n_args -le $((a+1)) ] && error_arg "$arg"
    opt="${args[((++a))]}"
    arg="${args[((++a))]}"
}
parse_flgopt() {
    case "$arg" in
        -[H$arg_flgs]*)
            [[ "H$arg_flgs$arg_opts" =~ ${arg:2:1} ]] ||error_opt "-${arg:2:1}"
            args[a--]="-${arg:2}"
            arg="${arg:0:2}" ;;
        -[$arg_opts]*)
            args[a]="${arg:2}"
            arg="${arg:0:2}"
            ((a--)) ;;
    esac
}

## main ::
trap exit INT
while [ -n "$arg" ]; do case "$arg" in
    -V|--verbose) parse_flg; flg_verbose=true;;
    -r|--remote) parse_opt; opt_rhost="$opt";;
    -H*|--help) print_help; exit 0;;
    -[$arg_flgs$arg_opts]*) parse_flgopt;;
    --) ((a++)); break ;;
    *) break ;;
esac; done
pargs=("${args[@]:a}")

# dependency error:
for d in "${deps[@]}"; do is_cmd "$d" || error "missing dependency: $d"; done

# resolve lhost and rhost:
[ -f '/etc/hostname' ] && lhost="$(cat /etc/hostname)"
[ -f '/etc/hostname-' ] && lhost="$(cat /etc/hostname-)"
rhost="${opt_rhost:-$rhost}"
[[ "$rhost" =~ ^(|$lhost|127.0.0.1)$ ]] && rhost='localhost'

#trap <cleanup_function> EXIT

msg2 "flg_verbose: $flg_verbose"
msg2 "rhost: $rhost"

read -erp $'\e[1;38;5;10m'': '$'\e[0;38;5;15m''print pargs? [Y/n] '$'\e[0m' ans
if [ -z "$ans" ] || [ "${ans,,}" = 'y' ] || [ "${ans,,}" = 'yes' ]; then
    msg2 "$(for p in "${pargs[@]}"; do printf '%q ' "$p"; done)"
fi

# vim:ft=bash
