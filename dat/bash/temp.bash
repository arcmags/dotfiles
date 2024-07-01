#!/bin/bash
## temp.bash ::

print_help() {
cat <<'HELPDOC'
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
}

## internal control ::
dir_script="$(cd "$(dirname "$BASH_SOURCE")" && pwd)"
file_script="$(basename "$BASH_SOURCE")"
path_script="$(realpath "$BASH_SOURCE")"
pid_script="$$"
reqs=()

# args:
a=0 arg="$1" args=("$@")
flg_yes=false
opt_input=

## functions ::
error() { msg_error "$@"; exit 5 ;}
msg() { printf "\e[1;38;5;12m=> \e[0;38;5;15m$1\e[0m\n" "${@:2}" ;}
msg_cmd() { printf '\e[1;38;5;12m $\e[0;38;5;15m'; printf ' %q' "$@"; printf '\n' ;}
msg_error() { printf "\e[1;38;5;9mE: \e[0;38;5;15m$1\e[0m\n" "${@:2}" >&2 ;}
msg_to() { msg "$1$(printf ' \e[1;38;5;12m-> \e[0;38;5;15m%s\e[0m' "${@:2}")" ;}
msg_warn() { printf "\e[1;38;5;11mW: \e[0;38;5;15m$1\e[0m\n" "${@:2}" >&2 ;}
msg2() { printf "\e[1;38;5;12m > \e[0;38;5;15m$1\e[0m\n" "${@:2}" ;}

## main() ::
#trap <cleanup_function> EXIT
trap 'printf "\n"; error "caught SIGINT"' INT
while [ -n "$arg" ]; do case "$arg" in
    -Y|--yes) flg_yes=true; arg="${args[((++a))]}" ;;
    -H|--help) print_help; exit 0 ;;
    -i|--input)
        [ $# -le $((a+1)) ] && error "arg required: $arg" && exit 3
        opt_input="${args[((++a))]}"; arg="${args[((++a))]}" ;;
    -[HY]*)
        [[ ! "${arg:2:1}" =~ [HYi] ]] && error "unknown option: ${arg:2:1}"
        args[a--]="-${arg:2}"; arg="${arg:0:2}" ;;
    -[i]*) args[a]="${arg:2}"; arg="${arg:0:2}"; ((a--)) ;;
    --) ((a++)); break ;;
    *) break ;;
esac; done
args=("${args[@]:a}")

for req in "${reqs[@]}"; do if ! command -v "$req" &>/dev/null; then
    error "missing requirement: $req"
fi; done

if [ "$flg_yes" != true ]; then
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
