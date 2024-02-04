#!/bin/sh
## ~/.config/qutebrowser/userscripts/transmission.sh ::

print_help() {
cat <<'HELPDOC'
NAME
    transmission.sh

DESCRIPTION
    Userscript for qutebrowser to add selected url to the transmission-daemon
    download queue. Handles torrent files and magnet links.

USAGE
    Copy transmission.sh to qutebrowser userscript directory.

    Add link to transmission-daemon queue:
        :hint links userscript transmission.sh

REQUIREMENTS
    transmission-daemon must be running.
HELPDOC
}

# internal control:
url="$QUTE_URL"

## functions ::
msg() {
    printf 'message-info "%s"\n' "$*" > "$QUTE_FIFO"
}

msg_error() {
    printf 'message-error "E: %s"\n' "$*" > "$QUTE_FIFO"
}

msg_warn() {
    printf 'message-warning "W: %s"\n' "$*" > "$QUTE_FIFO"
}

## main ::
if [ -z "$QUTE_FIFO" ]; then
    print_help
    exit 0
fi

# check transmission-daemon:
if ! pidof -q transmission-daemon; then
    msg_error '[transmission-daemon] not running'
    exit 0
fi

# non-magnet links:
if ! printf '%s' "$url" | grep -qi '^magnet:'; then
    torrent_tmp="$(mktemp --tmpdir XXX.torrent)"
    if ! curl -s -o "$torrent_tmp" "$url"; then
        rm "$torrent_tmp"
        msg_error '[curl] download error'
        exit 0
    fi
    url="$torrent_tmp"
fi

# add torrent:
if transmission-remote -a "$url" >/dev/null 2>&1; then
    msg '[transmission-remote] torrent added'
else
    msg_error '[transmission-remote] torrent error'
fi

# cleanup:
if [ -f "$torrent_tmp" ]; then
    rm "$torrent_tmp"
fi
