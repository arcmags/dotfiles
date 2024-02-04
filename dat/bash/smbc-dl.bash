#!/bin/bash

## smbc-dl.bash ::
# Download every comic from smbc-comics.com.
# [old]

url_base=https://www.smbc-comics.com
url="$url_base/comic/2002-09-05"
green_b=$'\e[1;38;5;46m'
white=$'\e[0;38;5;15m'
white_b=$'\e[1;37m'
gray=$'\e[0;37m'

msg() {
    local msg="$(fmt -w $(tput cols) <<<"    $1")"
    printf '%s==>%s %s%s\n' "$green_b" "$white_b" "${msg:4}" "$gray"
}

wget_file() {
    local url="$1"
    local url_file="$2"
    local n_tries=16
    local n=0
    local c=1
    if [ -z "$2" ]; then
        url_file="${url##*/}"
        url_file="${url_file%%\?*}"
    fi
    if [ -f "$url_file" ]; then
        while [ -f "${url_file}_$c" ]; do
            ((c++))
        done
        url_file="${url_file}_$c"
    fi
    while [ $n -lt $n_tries ] && [ ! -f "$url_file" ]; do
        wget -q -U 'Mozilla' --timeout=8 --waitretry=$n_tries \
            --tries=$n_tries --retry-connrefused -O "$url_file" "$url"
        sleep $n
        ((n++))
    done
    if [ -f "$url_file" ]; then
        return 0
    else
        return 1
    fi
}

wget_html() {
    local url="$1"
    local n_tries=16
    local n=0
    local html=
    while [ $n -lt $n_tries ] && [ ! -n "$html" ]; do
        html=$(wget -q -U 'Mozilla' --timeout=8 --waitretry=$n_tries \
            --tries=$n_tries --retry-connrefused -O - "$url")
        sleep $n
        ((n++))
    done
    if [ -n "$html" ]; then
        printf '%s\n' "$html"
        return 0
    else
        return 1
    fi
}

## main ::
c=1
while [ -n "$url" ]; do
    html="$(wget_html "$url")"
    title="$(grep -Po '/comic/\K.*' <<<"$url")"
    comic="$(grep -Po 'comics/\K.*?(?=" id="cc-comic")' <<<"$html")"
    msg "$title"
    wget_file "$url_base/comics/$comic" \
        "$(printf '%04d' $c)_$title.${comic#*.}"
    ((c++))
    url="$(grep -Po '<div id="cc-comicbody">\s*<a href="\K[^"]+' \
        <<<"$html")"
done

# vim:ft=bash
