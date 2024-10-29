#!/bin/bash
## ~/.bashrc ::

[[ $- != *i* ]] && return 0

[ -f "$HOME/.profile" ] && . "$HOME/.profile"

if is_bin fzf; then
    if [ -f "$HOME/.config/fzf/profile.bash" ]; then
        . "$HOME/.config/fzf/profile.bash"
    elif [ -f /usr/share/fzf/key-bindings.bash ]; then
        . /usr/share/fzf/key-bindings.bash
    fi
fi

set -o vi
shopt -s dotglob globstar failglob
complete -cf apropos do ltrace man strace sudo time torsocks watch
trap 'printf "\033]0;%s\007" "${BASH_COMMAND:0:32}"' DEBUG

## functions: aliases ::
cd-() { cd - >/dev/null || return 1 ;}
[ -d "$UDIR/.user" ] && cd.() { cd "$UDIR/.user" ;}
cd..() { cd .. ;}
cd/() { cd / || return 1 ;}
is_bin ffmpeg && ffmpeg-mp3() { for arg in "$@"; do ffmpeg -i "$arg" "${arg%.*}.mp3"; done ;}
is_bin yt-dlp && yt-dlp-audio() { command yt-dlp -f 'ba[ext=m4a]' -x "$@" ;}

## functions: commands ::
reload() { [ -f "$HOME/.inputrc" ] && bind -f "$HOME/.inputrc"; . "$HOME/.bashrc" ;}

## execute commands ::
tty | grep /dev/tty -q && command -v termset &>/dev/null && termset

# vim:ft=bash
