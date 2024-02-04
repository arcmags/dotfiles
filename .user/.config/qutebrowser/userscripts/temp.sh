#!/bin/sh
## ~/.config/qutebrowser/userscripts/temp.sh ::

print_help() {
cat <<'HELPDOC'
NAME
    <script>

DESCRIPTION
    Template Userscript for qutebrowser.

USAGE
    Copy <script> to qutebrowser userscript directory.

    <do stuff>:
        :hint links userscript <script>

REQUIREMENTS
    [app...] must be installed.
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
