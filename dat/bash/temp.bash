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

## control ::
deps=()
host="$HOSTNAME"
path_script="$(realpath "$BASH_SOURCE")"
pid_script="$$"
remote='localhost'
script="$(basename "$0")"

## args ::
flg_verbose=false
opt_remote=

## args: parse ::
a=0 arg="$1" args=("$@") pargs=() opt= flg=
parse_flg() { arg="${args[((++a))]}" ;}
parse_opt() {
    [ ${#args[@]} -le $((a+1)) ] && error "arg required: $arg"
    opt="${args[((++a))]}"; arg="${args[((++a))]}"
}

## functions ::
error() { msg_error "$@"; exit 5 ;}
input() { read -erp $'\e[1;38;5;10m''> '$'\e[0;38;5;15m'"$1 "$'\e[0m' "$2" ;}
is_cmd() { command -v "$1" &>/dev/null ;}
is_img() { [ -f "$1" ] && identify "$1" &>/dev/null ;}
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

## main ::
trap exit INT
while [ -n "$arg" ]; do case "$arg" in
    -V|--verbose) parse_flg; flg_verbose=true ;;
    -H|--help) print_help; exit 0 ;;
    -r|--remote) parse_opt; opt_remote="$opt" ;;
    -[HV]*)
        [[ ! "${arg:2:1}" =~ [HVr] ]] && error "unknown option: ${arg:2:1}"
        args[a--]="-${arg:2}"; arg="${arg:0:2}" ;;
    -[r]*) args[a]="${arg:2}"; arg="${arg:0:2}"; ((a--)) ;;
    --) ((a++)); break ;;
    *) break ;;
esac; done
pargs=("${args[@]:a}")

# dependency error:
for dep in "${deps[@]}"; do is_cmd "$dep" || error "not found: $dep"; done

# resolve host and remote:
[ -f '/etc/hostname' ] && host="$(cat /etc/hostname)"
[ -f '/etc/hostname-' ] && host="$(cat /etc/hostname-)"
remote="${opt_remote:-$remote}"
[[ "$remote" =~ ^(|$host|127.0.0.1)$ ]] && remote='localhost'

#trap <cleanup_function> EXIT

read -erp $'\e[1;38;5;10m'': '$'\e[0;38;5;15m''print pargs? [Y/n] '$'\e[0m' ans
if [ -z "$ans" ] || [ "${ans,,}" = 'y' ] || [ "${ans,,}" = 'yes' ]; then
    for a in "${pargs[@]}"; do printf '%q ' "$a"; done
    [ ${#pargs[@]} -gt 0 ] && printf '\n'
fi

# vim:ft=bash
