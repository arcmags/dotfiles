#!/bin/sh
## ~/.config/qutebrowser/userscripts/vim.sh ::

print_help() {
cat <<'HELPDOC'
NAME
    vim.sh

DESCRIPTION
    Userscript for qutebrowser to open html source in xterm vim window.

USAGE
    Copy vim.sh to qutebrowser userscript directory.

    Open url in xterm vim window:
        :spawn -u vim.sh
        :hint links userscript vim.sh

REQUIREMENTS
    xterm and vim must be installed.
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

# open current page source and text in vim:
if [ "$QUTE_MODE" = 'command' ]; then
    msg "[vim] $QUTE_HTML $QUTE_TEXT"
    xterm -T 'xterm_float' -e vim "$QUTE_HTML" "$QUTE_TEXT"

# downloaded hinted url and open in vim:
else
    file_tmp="$(mktemp)"
    # check download:
    if ! curl -s -o "$file_tmp" "$url"; then
        msg_error "[curl] $url"
        exit 0
    fi
    # open downloaded source in vim:
    msg "[vim] $file_tmp"
    xterm -T 'xterm_float' -e vim "$file_tmp"
    rm "$file_tmp"
fi
