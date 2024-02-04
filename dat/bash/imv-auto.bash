#!/bin/bash

## imv-auto ::

# internal control:
pid_imv=

## functions ::
msg() {
	printf "\e[1;38;5;12m==> \e[0;38;5;15m$1\e[0m\n" "${@:2}"
}

msg_error() {
	printf "\e[1;38;5;9m==> ERROR: \e[0;38;5;15m$1\e[0m\n" "${@:2}" >&2
}

msg2() {
	[ "$flag_quiet" = 'true' ] && return
	printf "\e[1;38;5;12m -> \e[0;38;5;15m$1\e[0m\n" "${@:2}"
}

# ERROR: missing inotifywait:
if ! command -v inotifywait &>/dev/null; then
    msg_error 'missing: inotifywait'
    exit 2
fi

# ERROR: missing imv:
if ! command -v imv &>/dev/null; then
    msg_error 'missing: imv'
    exit 2
fi

msg 'imv-auto: %s' "$PWD"
inotifywait -m -e move --format '%f' "$PWD" 2>/dev/null | \
while read file_in; do
    ext="${file_in##*.}"
    ext="${ext,,}"
    [ "$ext" = 'part' ] && continue
    if [[ "$ext" =~ jpg|jpeg|png|webp|gif ]]; then
        if ps --pid "$pid_imv" &>/dev/null; then
            imv-msg "$pid_imv" open "$(printf '%q' "$file_in")"
            imv-msg "$pid_imv" goto -1
        else
            imv "$file_in" &>/dev/null &
            pid_imv="$!"
            msg "$pid_imv"
        fi
        msg "$file_in"
    fi
done

# vim:ft=bash
