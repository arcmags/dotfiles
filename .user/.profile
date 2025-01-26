#!/bin/sh
## ~/.profile ::

## user setup: UDIR, UHOST, upwd() ::
export HOME_REALPATH="$(realpath "$HOME")"
export UDIR="$HOME/user"
export UDIR_REALPATH="$(realpath "$UDIR")"
export UHOST="$HOSTNAME"
[ -f '/etc/hostname' ] && UHOST="$(cat /etc/hostname)"
[ -f '/etc/hostname-' ] && UHOST="$(cat /etc/hostname-)"

upwd() {
    case "$PWD" in
        "$UDIR_REALPATH"*) printf '%s' "-${PWD#$UDIR_REALPATH}" ;;
        "$HOME_REALPATH"*) printf '%s' "~${PWD#$HOME_REALPATH}" ;;
        *)  PWD_REALPATH="$(realpath "$PWD")"; case "$PWD_REALPATH" in
            "$UDIR_REALPATH"*) printf '%s' "-${PWD_REALPATH#$UDIR_REALPATH}" ;;
            "$HOME_REALPATH"*) printf '%s' "~${PWD_REALPATH#$HOME_REALPATH}" ;;
            *) printf '%s' "$PWD" ;;
    esac; esac
}

## utils ::
is_bin() (
    IFS=':'
    for dir in $PATH; do [ -f "$dir/$1" ] && [ -x "$dir/$1" ] && return 0; done
    return 1
)

# TODO: take multiple args?
path_add() {
    expr ":$PATH:" : '.*:'"$1"':.*' >/dev/null 2>&1 || export PATH="$1${PATH:+:$PATH}"
}

## path ::
path_add "$HOME/.local/bin"
path_add "$UDIR/bin"
path_add "$UDIR/local/bin"
path_add "$HOME/bin"

## environment ::
command_not_found_handle() { printf '\e[1;38;5;11mC: \e[0;38;5;15m%s\e[0m\n' "$1"; return 127 ;}

#export ENV="$HOME/.profile"

export PS1='\[\e[0;38;5;6m\]$UHOST\[\e[1;38;5;10m\]:\[\e[38;5;12m\]$(upwd)\[\e[38;5;10m\]\$\[\e[0m\] '
export PS2='\[\e[0m\] '
[ "$USER" = 'dery' ] && PS1='\[\e[0;38;5;13m\]$UHOST\[\e[1;38;5;10m\]:\[\e[38;5;12m\]$(upwd)\[\e[38;5;10m\]\$\[\e[0m\] '

[ -d "$UDIR/lib/python" ] && export PYTHONPATH="$UDIR/lib/python"

[ -d "$UDIR/lib/figfonts" ] && export FIGLET_FONTDIR="$UDIR/lib/figfonts"

is_bin gpg && gpg --list-secret-keys '4742C8240A64DA01' >/dev/null 2>&1 && export GPGKEY='4742C8240A64DA01'

export SUDO_PROMPT="$(printf '\e[1;38;5;9m:> \e[0;38;5;15mpassword: \e[0m')"
su() { printf '\e[1;38;5;9m:> \e[0;38;5;15m'; command su "$@" ;}

[ "$TERM" = 'linux' ] && export TERM='linux-16color'

is_bin w3m && export BROWSER='w3m'

export COLORFGBG='7;0'

export TMPDIR='/tmp'

export EDITOR='vim'
export VISUAL="$EDITOR"
export FCEDIT="$EDITOR"
export SUDO_EDITOR="$EDITOR"
export SYSTEMD_EDITOR="$EDITOR"

export DICTIONARY='en_US'

[ -f "$HOME/.lscolors" ] && eval "$(dircolors "$HOME/.lscolors")" || eval "$(dircolors)"

export GREP_COLORS='mt=38;5;3:mc=48;5;3;38;5;0:fn=38;5;14:ln=38;5;8:bn=38;5;4:se=1;38;5;5'

export GROFF_NO_SGR=

is_bin fzf && [ -f "$HOME/.config/fzf/profile.sh" ] && . "$HOME/.config/fzf/profile.sh"

export HISTSIZE=4096
export HISTFILESIZE=4096
export HISTCONTROL='ignoredups:ignorespace:erasedups'
export HISTIGNORE='cd[dgilmpst./-]:cdtt*:bg:builtin cd*:fg:exit:poweroff:reboot:startx'
export CDHISTSIZE=16

export JQ_COLORS='0;38;5;6:0;38;5;11:0;38;5;11:0;38;5;3:0;38;5;10:0;38;5;13:0;38;5;13:0;38;5;12'

export LESS='-i -x4 -M -R -~ --mouse --wheel-lines=4 --intr=q$ -PM ?f%f:[stdin]. ?m(%i/%m) .| %L lines | ?eBot:%Pb\%. | %lt-%lb $'
if less --help | grep -q 'use-color'; then
    LESS="$LESS"' --use-color -DsG$ -DdB$ -DuC$ -DkG$ -DEGb$ -DNK$ -DPGb$ -DSyb$ -DRK$ -DMg$'
else
    export LESS_TERMCAP_mb="$(printf '\e[38;5;12m')"
    export LESS_TERMCAP_md="$(printf '\e[38;5;12m')"
    export LESS_TERMCAP_me="$(printf '\e[0m')"
    export LESS_TERMCAP_se="$(printf '\e[0m')"
    export LESS_TERMCAP_so="$(printf '\e[48;5;4;38;5;10m')"
    export LESS_TERMCAP_ue="$(printf '\e[0m')"
    export LESS_TERMCAP_us="$(printf '\e[38;5;14m')"
fi
LESS="$LESS"' +Gg'

export MANPAGER='less -m'
export MANLESS=' man $MAN_PN | %L lines | ?eBot:%pb\%. | %lt-%lb '

export MINICOM='-c on'

export PROMPT_COMMAND='printf "\033]0;%s\007" "${SHELL##*/}"'

export PAGER='less'

export RIPGREP_CONFIG_PATH="$HOME/.rg.conf"

export S_COLORS='always'
export S_COLORS_SGR='H=33;1:I=36;1:M=34;1:N=32;1:Z=34;1'

export ZSTD_CLEVEL=19

## functions: aliases ::
is_bin ash && [ -f "$HOME/.ashrc" ] && ash() { ENV="$HOME/.ashrc" command ash ;}

cdb() { cd "$UDIR/bin" ;}
cdd() { cd "$UDIR/dat" ;}
cdg() { cd "$UDIR/git" ;}
[ -d "$UDIR/usync/images" ] && cdi() { cd "$UDIR/usync/images" ;}
cdl() { cd "$UDIR/local" ;}
cdm() { cd /mnt ;}
[ -d /mnt/nas ] && cdn() { cd /mnt/nas ;}
[ -d "$UDIR/urepo" ] && cdr() { cd "$UDIR/urepo" ;}
[ -d "$UDIR/usync" ] && cds() { cd "$UDIR/usync" ;}
cdt() { cd "$TMPDIR" ;}
cdu() { cd "$UDIR" ;}
[ -d /mnt/nas/share/videos ] && cdv() { cd /mnt/nas/share/videos ;}
[ -d "$UDIR/www" ] && cdw() { cd "$UDIR/www" ;}

is_bin diff && diff() { command diff --color=auto "$@" ;}

is_bin ffmpeg && ffmpeg() { command ffmpeg -hide_banner "$@" ;}
is_bin ffplay && ffplay() { command ffplay -hide_banner "$@" ;}
is_bin ffprobe && ffprobe() { command ffprobe -hide_banner "$@" ;}

is_bin git && git() { GPG_TTY=$(tty) command git "$@" ;}

is_bin gpg && gpg() { command gpg --no-greeting -q "$@" ;}

grep() { command grep --color=auto "$@" ;}

ip() { command ip -color=auto "$@" ;}

lls() { ls --color=always | less -R ;}
ls1() { ls -1 "$@" ;}
ls() { LANG=C command ls -ALh --color=auto --group-directories-first "$@" ;}
lsl() { ls -l "$@" ;}
lss() { ls -s "$@" ;}

lsblk() { command lsblk -i "$@" ;}
lsb() { lsblk -o NAME,FSTYPE,SIZE,FSUSED,MOUNTPOINTS,UUID "$@" ;}

is_bin minicom && minicom() { command minicom -F ' /dev/%D | %T | %C ' "$@" ;}

is_bin mpv && ! is_bin mvp && mvp() { command mpv "$@" ;}

is_bin pactree && pactree() { command pactree -a "$@" ;}

is_bin ranger && ranger() {
    command ranger --choosedir="$TMPDIR/rangerdir.txt" "$@"
    cd "$(cat $TMPDIR/rangerdir.txt)"
}

reset() { tput reset ;}

is_bin run0 && run0() { command run0 --background= "$@" ;}

is_bin stylelint && stylelint() {
    if [ -f "$HOME/.stylelintrc.yml" ]; then
        command stylelint -f unix -c "$HOME/.stylelintrc.yml" "$@"
    else
        command stylelint -f unix "$@"
    fi
}

is_bin tmux && tmux() { command tmux -2 "$@" ;}

is_bin tt && tt() { command tt -notheme -noskip -blockcursor -nohighlight "$@" ;}

is_bin vim && [ "$TERM" = 'linux' ] && vim() { TERM='linux-16color' command vim "$@" ;}

is_bin startx && [ -f "$HOME/.xinitrc" ] && startx() { command startx "$HOME/.xinitrc" "$@" ;}

is_bin zathura && zathura() { command zathura --fork "$@" ;}

## functions: commands ::
# TODO: make these all scripts?
ascii() {
    is_bin iconv || error 'missing dep: iconv'
    cat "${1:-/dev/stdin}" | iconv -f utf-8 -t ascii//TRANSLIT
}

bak() (
    suffix="_$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$UDIR/dat/bak"
    for a in "$@"; do
        [ ! -e "$a" ] && continue
        cp -r "$a" "$UDIR/dat/bak/$a$suffix"
    done
)

calc() {
    is_bin bc || error 'missing dep: bc'
    printf 'scale=3;%s\n' "$*" | bc -l
}

cdtt() {
    dir_tmp="$(mktemp -d "$TMPDIR/tmp.XXX.d")"
    [ -n "$1" ] && cp -r "$@" "$dir_tmp"
    cd "$dir_tmp"
    unset dir_tmp
}

error() { printf '\e[1;38;5;9mE: \e[0;38;5;15m%s\e[0m\n' "$*" >&2; return 2 ;}

gpgreset() {
    is_bin gpgconf || error 'missing dep: gpgconf'
    gpgconf --kill gpg-agent
}

reload() { . "$HOME/.profile" ;}

pkgbuild() {
    curl -s "https://gitlab.archlinux.org/archlinux/packaging/packages/$1/-/raw/main/PKGBUILD"
}

screenshot() {
    png_screen="/tmp/screen_$(date +'%F_%H-%M-%S').png"
    if [ -n "$DISPLAY" ]; then
        is_bin import || error 'missing dep: import'
        import -window root "$png_screen" && printf '%s\n' "$png_screen"
    else
        is_bin fbgrab || error 'missing dep: fbgrab'
        groups | grep -qw 'video' || error 'not in group: video'
        fbgrab "$png_screen" >/dev/null 2>&1 && printf '%s\n' "$png_screen"
    fi
    unset png_screen
}

tb() {
    is_bin nc || error 'missing dep: nc'
    url_tb="$(cat "${1:-/dev/stdin}" | nc termbin.com 9999 | tr -d '\0')"
    [ -z "$url_tb" ] && error 'connection error'
    printf '%s\n' "$url_tb"
    [ -n "$DISPLAY" ] && is_bin xclip && printf '%s' "$url_tb" | xclip
    unset url_tb
}

tempcp() {
    mkdir -p "$TMPDIR/temp"
    find "$UDIR/dat" -maxdepth 2 -regex '.*/temp[._].+' | while IFS= read -r temp; do
        cp "$temp" "$TMPDIR/temp"
    done
}

termset() {
    if tty | grep /dev/tty -q; then
        [ -f "$UDIR/.user/.cache/wal/colors-tty.sh" ] && sh "$UDIR/.user/.cache/wal/colors-tty.sh"
        [ -f "$HOME/.cache/wal/colors-tty.sh" ] && sh "$HOME/.cache/wal/colors-tty.sh"
    elif [ -z "$TMUX" ]; then
        [ -f "$UDIR/.user/.cache/wal/sequences" ] && cat "$UDIR/.user/.cache/wal/sequences"
        [ -f "$HOME/.cache/wal/sequences" ] && cat "$HOME/.cache/wal/sequences"
    fi
}

titleset() { [ -n "$1" ] && printf '\033]0;%s\007' "$*" ;}

uvim() {
    is_bin vim || error 'missing dep: vim'
    if [ -f "$UDIR/.user/.vim/.uvim" ]; then
        vim -c "source $UDIR/.user/.vim/.uvim" "$@"
    else
        vim "$@"
    fi
}

usudo() { is_bin sudo || error 'missing dep: sudo'; command sudo -E env "PATH=$PATH" "$@" ;}

xclip() {
    is_bin xclip || error 'missing dep: xclip'
    [ -z "$DISPLAY" ] && error 'no display'
    command xclip -sel clipboard "$@"
}
xput() { xclip -o ;}
xyank() { xclip ;}

xreload() {
    [ -z "$DISPLAY" ] && error 'no display'
    [ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources"
}

# vim:ft=sh
