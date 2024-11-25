#!/bin/bash
## t{cmd} ::

print_help() { cat <<'HELPDOC'
NAME
    t{cmd} - attach/create tmux {cmd} session

SYNOPSIS
    t{cmd} [OPTION...]

DESCRIPTION
    Create tmux {cmd} session (if it doesn't exist) and attach to it.
    Optionally run script on remote host over ssh.

OPTIONS
    -r, --remote HOST
        Set remote hostname. (default: localhost)

    -H, --help
        Print help.
HELPDOC
}; [ "$0" != "$BASH_SOURCE" ] && { print_help; return 0 ;}

## control ::
cmd='{cmd}'
deps=(ssh tmux)
host="$HOSTNAME"
remote='localhost'
script="$(basename "$0")"
session="${cmd%% *}"
settings=('status off' 'pane-border-status off')
socket="$session"

# args:
a=0 arg="$1" args=("$@")
opt_remote=

## functions ::
error() { msg_error "$@"; exit 5 ;}
is_cmd() { command -v "$1" &>/dev/null ;}
msg_debug() { printf "[%d] %s\n" $BASH_LINENO "$*" ;}
msg_error() { printf '\e[1;38;5;9mE: \e[0;38;5;15m%s\e[0m\n' "$*" >&2 ;}

## main ::
trap exit INT
while [ -n "$arg" ]; do case "$arg" in
    -H|--help) print_help; exit 0 ;;
    -r|--remote)
        [ $# -le $((a+1)) ] && error "arg required: $arg"
        opt_remote="${args[((++a))]}"; arg="${args[((++a))]}" ;;
    -[H]*)
        [[ ! "${arg:2:1}" =~ [Hr] ]] && error "unknown option: ${arg:2:1}"
        args[a--]="-${arg:2}"; arg="${arg:0:2}" ;;
    -[r]*) args[a]="${arg:2}"; arg="${arg:0:2}"; ((a--)) ;;
    --) ((a++)); break ;;
    *) break ;;
esac; done
args=("${args[@]:a}")

# dependency error:
for dep in "${deps[@]}"; do is_cmd "$dep" || error "not found: $dep"; done

# resolve host and remote:
[ -f '/etc/hostname' ] && host="$(cat /etc/hostname)"
[ -f '/etc/hostname-' ] && host="$(cat /etc/hostname-)"
remote="${opt_remote:-$remote}"
[[ "$remote" =~ ^(|$host|127.0.0.1)$ ]] && remote='localhost'

# run script on remote via ssh:
[ "$remote" != 'localhost' ] && exec ssh -t "$remote" "bash -li -c $script"

# create tmux session:
if ! tmux -L "$socket" has-session -t "$session" >/dev/null 2>&1; then
    tmux -L "$socket" new-session -d -s "$session" "$cmd"
    tmux -L "$socket" select-pane -T "$session"
    for setting in "${settings[@]}"; do tmux -L "$socket" set $setting; done
fi

# attach tmux session:
exec tmux -L "$session" attach-session -t "$session"

# vim:ft=sh
