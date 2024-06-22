#!/bin/sh
## ~/.config/qutebrowser/userscripts/zathura.sh ::

print_help() {
cat <<'HELPDOC'
NAME
    zathura.sh

DESCRIPTION
    Userscript for qutebrowser to download and open selected url in zathura.

USAGE
    Copy zathura.sh to qutebrowser userscript directory.

    Open url in zathura:
        :spawn -u zathura.sh
        :hint links userscript zathura.sh

REQUIREMENTS
    wget
    zathura
HELPDOC
}

# internal control:
url="$QUTE_URL"
file="${url##*/}"

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

cd "$QUTE_DOWNLOAD_DIR"

# download file:
if [ ! -e "$file" ] && ! wget -q "$url"; then
    msg_error "[wget] $url"
    exit 0
fi

# open file in zathura:
msg "[zathura] $file"
zathura "$file"
