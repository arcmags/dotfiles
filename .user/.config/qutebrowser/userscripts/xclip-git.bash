#!/bin/bash
## ~/.config/qutebrowser/userscripts/xclip-git.bash ::

print_help() {
cat <<'HELPDOC'
NAME
    xclip-git.bash

DESCRIPTION
    Userscript for qutebrowser to parse and yank root .git url to x-clipboard.
    Works with github, gitlab, aur, and archlinux urls.

USAGE
    Copy xclip-git.bash to qutebrowser userscript directory.

    Yank root .git url to clipboard:
        :spawn -u xclip-git.bash
        :hint links userscript xclip-git.bash

REQUIREMENTS
    xclip must be installed.
HELPDOC
}

# internal control:
url="$QUTE_URL"
url_github='git@github.com:'
url_gitlab='git@gitlab.com:'
url_aur='ssh+git://aur@aur.archlinux.org/'
url_archlinux='https://gitlab.archlinux.org/archlinux/packaging/packages/'
url_xclip=

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

# parse url:
if [[ "$url" =~ ^https://github\.com/([^/]+/[^/]+).* ]]; then
    url_xclip="$url_github${BASH_REMATCH[1]}.git"
elif [[ "$url" =~ ^https://gitlab\.com/([^/]+/[^/]+).* ]]; then
    url_xclip="$url_gitlab${BASH_REMATCH[1]}.git"
elif [[ "$url" =~ ^https://archlinux\.org/packages/[^/]+/[^/]+/([^/]+).* ]]; then
    url_xclip="$url_archlinux${BASH_REMATCH[1]}.git"
elif [[ "$url" =~ ^https://aur\.archlinux\.org/packages/([^/]+).* ]]; then
    url_xclip="$url_aur${BASH_REMATCH[1]}.git"
elif [[ "$url" =~ ^https://aur\.archlinux\.org/cgit/.*h=(.+)$ ]]; then
    url_xclip="$url_aur${BASH_REMATCH[1]}.git"
else
    msg_error 'unrecognized url'
    exit 0
fi

# copy .git url to clipboard:
msg "[xclip] $url_xclip"
printf '%s' "$url_xclip" | xclip -sel clipboard

# vim: ft=bash
