#!/bin/bash
## daemon.bash ::

print_help() {
cat <<'HELPDOC'
NAME
    daemon.bash - run and send stdin to daemon process

SYNOPSIS
    daemon.bash [OPTION...] <ACTION> [ARG...]

DESCRIPTION
    Bash daemon process example script. Uses a named fifo to recieve stdin.

ACTIONS
    start, srt
        Start process.

    stop, stp
        Send 'stop' string to process stdin.

    send, snd [TEXT...]
        Send TEXT string to process stdin.

    connect, con
        Connect to stdin of process. (send 'exit' to exit)

OPTIONS
    -F, --foreground
        Launch process in foreground.

    -H, --help
        Print help.
HELPDOC
}

## internal control ::
#reqs=()
fifo=/tmp/daemon.bash.fifo
log=/tmp/daemon.bash.log

# args:
a=0 arg="$1" args=("$@")
flg_yes=false
flg_srt=false
flg_snd=false
flg_con=false
opt_input=

## functions ::
error() { msg_error "$@"; exit 5 ;}
msg() { printf "\e[1;38;5;12m=> \e[0;38;5;15m$1\e[0m\n" "${@:2}" ;}
msg_ask() { printf "\e[1;38;5;10m:> \e[0;38;5;15m$1\e[0m " "${@:2}" ;}
msg_error() { printf "\e[1;38;5;9mE: \e[0;38;5;15m$1\e[0m\n" "${@:2}" >&2 ;}
msg_warn() { printf "\e[1;38;5;11mW: \e[0;38;5;15m$1\e[0m\n" "${@:2}" >&2 ;}
msg2() { printf "\e[1;38;5;12m > \e[0;38;5;15m$1\e[0m\n" "${@:2}" ;}

server() {
    # set cleanup:
    trap '{ kill "$pid_fifo" &>/dev/null; rm -f "$fifo" ;}' EXIT
    # create fifo:
    rm -f "$fifo" "$log"
    mkfifo "$fifo"
    chmod +t "$fifo"
    # open fifo for writing indefinately:
    sleep infinity >"$fifo" &
    pid_fifo=$!
    # open fifo for reading, direct to stdin of process:
    while read -r line; do
        [ "${line,,}" = 'stop' ] && break
        [ "$flg_fg" = true ] && printf ' > %s\n' "$line"
        printf ' > %s\n' "$line" >> "$log"
    done < "$fifo"
    exit
}

## main() ::
while [ -n "$arg" ]; do case "$arg" in
    start|srt) flg_srt=true; ((a++)); break ;;
    stop|stp) flg_stp=true; ((a++)); break ;;
    send|snd) flg_snd=true; ((a++)); break ;;
    connect|con) flg_con=true; ((a++)); break ;;
    -F|--fg|--foreground) flg_fg=true; arg="${args[((++a))]}" ;;
    -H|--help) print_help; exit 0 ;;
    -[FH]*)
        [[ ! "${arg:2:1}" =~ [FH] ]] && error "unknown option: ${arg:2:1}"
        args[a--]="-${arg:2}"; arg="${arg:0:2}" ;;
    --) ((a++)); break ;;
    *) break ;;
esac; done
args=("${args[@]:a}")

# start process:
if [ "$flg_srt" = true ]; then
    # start in foreground:
    if [ "$flg_fg" = true ]; then
        server
    # start as daemon:
    else
        server &
        sleep 0.2
        true >"$fifo"
    fi
    exit
fi

# fifo not found:
[ ! -p "$fifo" ] && error "fifo not found: $fifo"

# send stop command to daemon:
if [ "$flg_stp" = true ]; then
    printf 'stop\n' > "$fifo"
fi

# send single command to daemon:
if [ "$flg_snd" = true ]; then
    printf '%s\n' "${args[*]}" > "$fifo"
fi

# send commands to daemon:
if [ "$flg_con" = true ]; then
    msg 'connected to daemon.bash'
    while read -r -p $'\e[1;38;5;10m'"> "$'\e[0m' cmd; do
        cmd="${cmd,,}"
        [ "$cmd" = exit ] && break
        [[ ! "$cmd" =~ ^\ *$ ]] && printf '%s\n' "$cmd" > "$fifo"
        [ "$cmd" = stop ] && break
    done
fi

# vim:ft=bash
