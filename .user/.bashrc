#!/bin/bash
## ~/.bashrc ::

[[ $- != *i* ]] && return 0

## sources ::
[[ -f "$HOME/.profile" ]] && . "$HOME/.profile"
if is_bin fzf; then
    if [[ -f "$HOME/.config/fzf/profile.bash" ]]; then
        . "$HOME/.config/fzf/profile.bash"
    elif [[ -f /usr/share/fzf/key-bindings.bash ]]; then
        . /usr/share/fzf/key-bindings.bash
    fi
fi

## bash ::
complete -cf apropos 'do' ltrace man strace sudo time torsocks usudo watch
set -o vi
shopt -s dotglob globstar failglob
# set terminal window title to last executed command:
trap 'printf "\033]0;%s\007" "${BASH_COMMAND:0:32}"' DEBUG

## xclip ::
if [[ -n $DISPLAY ]] && is_bin xclip; then
    __xyank_line() { printf '%s' "$READLINE_LINE" | xclip -sel clipboard ;}
    bind -m vi-command -x '"Y": __xyank_line'
fi

## functions: aliases ::
cd-() { cd - >/dev/null || return 1 ;}
[[ -d "$UDIR/.user" ]] && cd.() { cd "$UDIR/.user" ;}
cd..() { cd .. ;}
cd/() { cd / || return 1 ;}
is_bin ffmpeg && ffmpeg-mp3() { for a in "$@"; do ffmpeg -i "$a" "${a%.*}.mp3"; done ;}
is_bin yt-dlp && yt-dlp-audio() { command yt-dlp -f 'ba[ext=m4a]' -x "$@" ;}

## functions: commands ::
reload() { [[ -f "$HOME/.inputrc" ]] && bind -f "$HOME/.inputrc"; . "$HOME/.bashrc" ;}

## main ::
# set tty terminal colors:
command -v termset &>/dev/null && [[ $(tty) == /dev/tty* ]] && termset

# vim:ft=bash
