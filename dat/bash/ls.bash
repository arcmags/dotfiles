#!/bin/bash
## ls.bash ::

print_help() {
cat <<'HELPDOC'
NAME
    temp.bash

SYNOPSIS
    temp.bash [-D] [-i INPUT] [ARG...]

DESCRIPTION
    Bash template script.

OPTIONS
    -i --input INPUT
        Set opt_input=INPUT

    -D, --dryrun
        Set flg_dryrun=true

    -H, --help
        Print help.
HELPDOC
}

## internal control ::
file_script="$(basename "$BASH_SOURCE")"
dir_script="$(cd "$(dirname "$BASH_SOURCE")" && pwd)"
path_script="$(realpath "$BASH_SOURCE")"
pid_script="$$"
opt_input=
flg_dryrun=false
reqs=()

# messages:
msg() { printf "\e[1;38;5;12m=> \e[0;38;5;15m$1\e[0m\n" "${@:2}" ;}
msg_ask() { printf "\e[1;38;5;10m:> \e[0;38;5;15m$1\e[0m " "${@:2}" ;}
msg_error() { printf "\e[1;38;5;9mE: \e[0;38;5;15m$1\e[0m\n" "${@:2}" >&2 ;}
msg_warn() { printf "\e[1;38;5;11mW: \e[0;38;5;15m$1\e[0m\n" "${@:2}" >&2 ;}
error() { msg_error "$@"; exit 5 ;}

#trap <cleanup_function> EXIT

## main() ::
while [ -n "$arg" ]; do case "$arg" in
    -i|--input)
        [ $# -le $((a+1)) ] && msg_error "arg required: $arg" && exit 3
        opt_input="${args[((++a))]}"; arg="${args[((++a))]}" ;;
    -D|--dryrun)
        flg_dryrun=true; arg="${args[((++a))]}" ;;
    -H|--help)
        print_help; exit 0 ;;
    -[DH]*)
        [[ ! "${arg:2:1}" =~ [DHi] ]] && error "unknown option: ${arg:2:1}"
        args[a--]="-${arg:2}"; arg="${arg:0:2}" ;;
    -[i]*)
        args[a]="${arg:2}"; arg="${arg:0:2}"; ((a--)) ;;
    --)
        ((a++)); break ;;
    *)
        break ;;
esac; done
args=("${args[@]:a}")

for req in "${reqs[@]}"; do if ! command -v "$req" &>/dev/null; then
    error "missing requirement: $req"
fi; done

mapfile -t files < <(find . -maxdepth 1 -type f -printf '%f\n' | sort)
[ "$flg_sortbysize" = 'true' ] && mapfile -t files < <(du -bs "${files[@]}" | sort -n | cut -f2)

mapfile -d ':' -t colors < <(printf '%s' "$LS_COLORS")

for color in "${colors[@]}"; do
    printf ' > %s\n' "$color"
done

# vim:ft=bash
