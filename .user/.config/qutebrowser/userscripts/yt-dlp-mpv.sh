#!/bin/sh
## ~/.config/qutebrowser/userscripts/yt-dlp-mpv.sh ::

print_help() {
cat <<'HELPDOC'
NAME
    yt-dlp-mpv.sh

DESCRIPTION
    Userscript for qutebrowser to play and/or download selected url.

USAGE
    Copy yt-dlp-mpv.sh to qutebrowser userscript directory.

    Play url:
        :spawn -u yt-dlp-mpv.sh
        :hint links userscript yt-dlp-mpv.sh

    Download url:
        :spawn -u yt-dlp-mpv.sh download-only {url}
        :hint links spawn -u yt-dlp-mpv.sh download-only {hint-url}

    Download and play url:
        :spawn -u yt-dlp-mpv.sh download {url}
        :hint links spawn -u yt-dlp-mpv.sh download {hint-url}

REQUIREMENTS
    mpv and yt-dlp must be installed.
HELPDOC
}

# internal control:
flag_dl=false
flag_play=true
file=
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

# parse args, set options:
if [ "$1" = 'download' ]; then
    flag_dl=true
    url="$2"
elif [ "$1" = 'download-only' ]; then
    flag_dl=true
    flag_play=false
    url="$2"
fi

# check url:
if [ -z "$url" ]; then
    msg_error 'no url'
    exit 0
elif [ "$url" = 'https://www.youtube.com/' ]; then
    msg_error 'only one video at a time'
    exit 0
fi

# get filename:
file="$(yt-dlp -o '%(title)s.%(ext)s' --get-filename "$url" | \
    sed -E -e 's/[^A-Za-z0-9_.-]//g' -e 's/_{2,}/_/g' -e 's/[_-]{2,}/-/g')"

# check filename:
if [ -z "$file" ]; then
    msg_error "[yt-dlp] $url"
    exit 0
elif [ "$(printf '%s' "$file" | wc -l)" -gt 1 ]; then
    msg_error 'only one video at a time'
    exit 0
fi

cd "$QUTE_DOWNLOAD_DIR"

# download video from url:
if [ "$flag_dl" = 'true' ] && [ ! -e "$file" ]; then
    msg "[yt-dlp] $file [...]"
    yt-dlp -o "$file" "$url"
    # check download:
    if [ ! -e "$file" ]; then
        msg_error "[yt-dlp] $url"
        exit 0
    fi
fi

# play video:
if [ "$flag_play" = 'true' ]; then
    if [ -e "$file" ]; then
        msg "[mpv] $file"
        mpv "$file"
    else
        msg "[mpv] $url"
        mpv "$url"
    fi

# print video filename:
else
    msg "[yt-dlp] $file [$(du -hs "$file" | cut -f1)]"
fi
