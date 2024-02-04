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
    zathura must be installed.
HELPDOC
}

# internal control:
url="$QUTE_URL"
file="${url##*/}"
file_ext="$(printf '%s' "${file##*.}" | tr '[:upper:]' '[:lower:]')"

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

# check file extension:
if [ "$file_ext" != 'pdf' ]; then
    msg_error "[zathura] $file"
    exit 0
fi

cd "$QUTE_DOWNLOAD_DIR"

# download file:
if [ ! -e "$file" ] && ! curl -s -o "$file" "$url"; then
    msg_error "[curl] $url"
    exit 0
fi

# open file in zathura:
msg "[zathura] $file"
zathura "$file"
