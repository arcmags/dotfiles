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
    -i, --input INPUT
        Set opt_input=INPUT

    -Y, --yes
        Set flg_yes=true

    -H, --help
        Print help.
HELPDOC
}; [ "$0" != "$BASH_SOURCE" ] && { print_help; return 0 ;}

## control ::
deps=()
dir_script="$(cd "$(dirname "$BASH_SOURCE")" && pwd)"
file_script="$(basename "$BASH_SOURCE")"
path_script="$(realpath "$BASH_SOURCE")"
pid_script="$$"

# args:
a=0 arg="$1" args=("$@")
flg_yes=false
opt_input=

## functions ::
error() { msg_error "$@"; exit 5 ;}
input() { read -erp $'\e[1;38;5;10m''> '$'\e[0;38;5;15m'"$1 "$'\e[0m' "$2" ;}
is_cmd() { command -v "$1" &>/dev/null ;}
is_img() { [ -f "$1" ] && identify "$1" &>/dev/null ;}
msg() { printf '\e[1;38;5;12m=> \e[0;38;5;15m%s\e[0m\n' "$*" ;}
msg2() { printf '\e[1;38;5;12m > \e[0;38;5;15m%s\e[0m\n' "$*" ;}
msg_cmd() { printf '\e[1;38;5;12m $\e[0;38;5;15m'; printf ' %q' "$@"; printf '\n' ;}
msg_error() { printf '\e[1;38;5;9mE: \e[0;38;5;15m%s\e[0m\n' "$*" >&2 ;}
msg_to() { msg "$1$(printf ' \e[1;38;5;12m-> \e[0;38;5;15m%s' "${@:2}")" ;}
msg_warn() { printf '\e[1;38;5;11mW: \e[0;38;5;15m%s\e[0m\n' "$*" >&2 ;}

## main() ::
trap exit INT
while [ -n "$arg" ]; do case "$arg" in
    -Y|--yes) flg_yes=true; arg="${args[((++a))]}" ;;
    -H|--help) print_help; exit 0 ;;
    -i|--input)
        [ $# -le $((a+1)) ] && error "arg required: $arg"
        opt_input="${args[((++a))]}"; arg="${args[((++a))]}" ;;
    -[HY]*)
        [[ ! "${arg:2:1}" =~ [HYi] ]] && error "unknown option: ${arg:2:1}"
        args[a--]="-${arg:2}"; arg="${arg:0:2}" ;;
    -[i]*) args[a]="${arg:2}"; arg="${arg:0:2}"; ((a--)) ;;
    --) ((a++)); break ;;
    *) break ;;
esac; done
args=("${args[@]:a}")

# check dependencies:
for dep in "${deps[@]}"; do is_cmd "$dep" || error "missing dep: $dep"; done

#trap <cleanup_function> EXIT

if [ "$flg_yes" = false ]; then
    read -erp $'\e[1;38;5;10m'': '$'\e[0;38;5;15m''print args? [Y/n] '$'\e[0m' ans
    [ -z "$ans" ] || [ "${ans,,}" = 'y' ] || [ "${ans,,}" = 'yes' ] && flg_yes=true
fi

if [ "$flg_yes" = true ]; then
    msg "opt_input: $opt_input"
    msg "flg_dryrun: $flg_dryrun"
    msg "args:"
    for arg in "${args[@]}"; do msg2 "$arg"; done
fi

# vim:ft=bash
