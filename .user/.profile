#!/bin/sh
## ~/.profile ::

## user setup: UDIR, UHOST, ULIB, upwd() ::
export HOME_REALPATH="$(realpath "$HOME")"
export UDIR="$HOME/user"
export UDIR_REALPATH="$(realpath "$UDIR")"
export UHOST="$HOSTNAME"
[ -f /etc/hostname ] && UHOST="$(cat /etc/hostname)"
[ -f /etc/hostname- ] && UHOST="$(cat /etc/hostname-)"
export ULIB="$UDIR/lib"

upwd() {
    PWD_REALPATH="$(realpath "$PWD")"
    case "$PWD_REALPATH" in
        "$UDIR_REALPATH"*) printf '%s' "-${PWD_REALPATH#"$UDIR_REALPATH"}" ;;
        "$HOME_REALPATH"*) printf '%s' "~${PWD_REALPATH#"$HOME_REALPATH"}" ;;
        *) printf '%s' "$PWD" ;;
    esac
}

## utils ::
is_bin() (
    IFS=':'
    for dir in $PATH; do [ -f "$dir/$1" ] && [ -x "$dir/$1" ] && return 0; done
    return 1
)

msg() { printf '\e[1;38;5;12m=> \e[0;38;5;15m%s\e[0m\n' "$*" ;}
msg_error() { printf '\e[1;38;5;9mE: \e[0;38;5;15m%s\e[0m\n' "$*" >&2 ;}
msg_good() { printf '\e[1;38;5;10m=> \e[0;38;5;15m%s\e[0m\n' "$*" ;}
msg_warn() { printf '\e[1;38;5;11mW: \e[0;38;5;15m%s\e[0m\n' "$*" >&2 ;}

path_add() {
    while [ -n "$1" ]; do
        expr ":$PATH:" : '.*:'"$1"':.*' >/dev/null 2>&1 || export PATH="$1${PATH:+:$PATH}"
        shift
    done
}

## path ::
path_add "$HOME/.local/bin" "$UDIR/bin" "$UDIR/local/bin" "$HOME/bin"

## environment ::
command_not_found_handle() { msg_error "$1: command not found"; return 127 ;}

export PS1='\[\e[0;38;5;6m\]$UHOST\[\e[1;38;5;10m\]:\[\e[38;5;12m\]$(upwd)\[\e[38;5;10m\]\$\[\e[0m\] '
export PS2='\[\e[0m\] '

[ -d "$ULIB/bash" ] && export BASHLIB="$ULIB/bash"
[ -d "$ULIB/figfonts" ] && export FIGLET_FONTDIR="$ULIB/figfonts"
[ -d "$ULIB/python" ] && export PYTHONPATH="$ULIB/python"
export PYTHONSTARTUP="$HOME/.pythonrc"

export GPGKEY='4742C8240A64DA01'

export SUDO_PROMPT="$(printf '\e[1;38;5;9m:> \e[0;38;5;15mpassword: \e[0m')"
su() { printf '\e[1;38;5;9m:> \e[0;38;5;15m'; command su "$@" ;}

[ "$TERM" = 'linux' ] && export TERM='linux-16color'

is_bin w3m && export BROWSER='w3m'
[ -n "$DISPLAY" ] && is_bin qutebrowser && export BROWSER='qutebrowser'

export COLORFGBG='7;0'

export TMPDIR='/tmp'

export EDITOR='vim'
export FCEDIT="$EDITOR"
export SUDO_EDITOR="$EDITOR"
export SYSTEMD_EDITOR="$EDITOR"
export VISUAL="$EDITOR"

export DICTIONARY='en_US'

[ -f "$HOME/.lscolors" ] && eval "$(dircolors "$HOME/.lscolors")" || eval "$(dircolors)"

export GREP_COLORS='mt=38;5;3:mc=48;5;3;38;5;0:fn=38;5;14:ln=38;5;8:bn=38;5;4:se=1;38;5;5'

export GROFF_NO_SGR=

is_bin fzf && [ -f "$HOME/.config/fzf/profile.sh" ] && . "$HOME/.config/fzf/profile.sh"

export HISTSIZE=4096
export HISTFILESIZE=4096
export HISTCONTROL='ignoredups:ignorespace:erasedups'
export HISTIGNORE='cd[dgilmpst./-]:bg:builtin cd*:fg:exit:poweroff:reboot:startx'
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

cd() {
    [ "$1" = '-' ] && { builtin cd -; return $? ;}
    [ -d "${1:-$HOME}" ] && { builtin cd "${1:-$HOME}"; return $? ;}
    msg_error "${1:-$HOME}: no such directory"; return 1
}
cdb() { cd "$UDIR/bin" ;}
cdd() { cd "$UDIR/dat" ;}
cdg() { cd "$UDIR/git" ;}
cdi() { cd "$UDIR/usync/images" ;}
cdl() { cd "$UDIR/local" ;}
cdm() { cd /mnt ;}
cdn() { cd /mnt/nas ;}
cdp() { cd "$UDIR/dat/python" ;}
cdr() { cd "$UDIR/urepo" ;}
cds() { cd "$UDIR/usync" ;}
cdt() { cd "$TMPDIR" ;}
cdu() { cd "$UDIR" ;}
cdv() { cd /mnt/nas/share/videos ;}
cdw() { cd "$UDIR/www" ;}

is_bin diff && diff() { command diff --color=auto "$@" ;}

is_bin ffmpeg && ffmpeg() { command ffmpeg -hide_banner "$@" ;}
is_bin ffplay && ffplay() { command ffplay -hide_banner "$@" ;}
is_bin ffprobe && ffprobe() { command ffprobe -hide_banner "$@" ;}

is_bin git && git() { GPG_TTY=$(tty) command git "$@" ;}

is_bin gpg && gpg() { command gpg --no-greeting -q "$@" ;}

grep() { command grep --color=auto "$@" ;}

ip() { command ip -color=auto "$@" ;}

ls() { LANG=C command ls -ALh --color=auto --group-directories-first "$@" ;}
ls1() { ls -1 "$@" ;}
lsl() { ls -l "$@" ;}
lss() { ls -s "$@" ;}
lls() { ls --color=always | less -R ;}

lsblk() { command lsblk -i "$@" ;}
lsb() { lsblk -o NAME,FSTYPE,SIZE,FSUSED,MOUNTPOINTS,UUID "$@" ;}

is_bin minicom && minicom() { command minicom -F ' /dev/%D | %T | %C ' "$@" ;}

is_bin mpv && ! is_bin mvp && mvp() { command mpv "$@" ;}

is_bin pactree && pactree() { command pactree -a "$@" ;}

is_bin ranger && ranger() {
    command ranger --choosedir="$TMPDIR/dir.txt" "$@" && cd "$(cat $TMPDIR/dir.txt)"
}

is_bin vifm && vifm() {
    command vifm --choose-dir="$TMPDIR/dir.txt" "$@" && cd "$(cat $TMPDIR/dir.txt)"
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
    is_bin iconv || { command_not_found_handle iconv; return $? ;}
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

calc() { printf 'scale=3;%s\n' "$*" | bc -l ;}

cdtt() {
    _d=01; _dir_tmp="$TMPDIR/tmp_$_d.d"
    while [ -d "$_dir_tmp" ]; do
        _d=$((_d + 1))
        [ "$_d" -lt 10 ] && _d="0$_d"
        _dir_tmp="$TMPDIR/tmp_$_d.d"
    done
    mkdir "$_dir_tmp"
    [ -n "$1" ] && cp -r "$@" "$_dir_tmp"
    cd "$_dir_tmp"
    unset _d _dir_tmp
}

exifclear() {
    is_bin exiftool || { msg_error 'missing dep: exiftool'; return 3 ;}
    exiftool -m -overwrite_original -all= "$@"
}

gpgreset() { gpgconf --kill gpg-agent ;}

reload() { . "$HOME/.profile" ;}

# TODO: check for legitimate package:
pkgbuild() {
    curl -s "https://gitlab.archlinux.org/archlinux/packaging/packages/$1/-/raw/main/PKGBUILD"
}

pythonpath() { python -c 'import sys; print(sys.path)' ;}

rwords() (
    _i=0 _j=0 _len="${1:-72}" _rand= _text=
    expr "$_len" : '[1-9][0-9]*' >/dev/null 2>&1 || { msg_error "invalid length: $_len"; return 3 ;}
    _rand="$(tr -cd 'a-z' </dev/random | head -c "$_len")"
    [ $_len -lt 9 ] && { printf '%s\n' "$_rand"; return ;}
    while [ $_i -lt $_len ]; do _j=$(($RANDOM%7+2)) _text+="${_rand:_i:_j} " _i=$((_i+_j)); done
    printf '%s\n' "${_text:0:_len}"
)

screenshot() (
    _png="/tmp/screen_$(date +'%F_%H-%M-%S').png"
    if [ -n "$DISPLAY" ]; then
        is_bin import || { msg_error 'missing dep: import'; return 3 ;}
        import -window root "$_png" && printf '%s\n' "$_png"
    else
        is_bin fbgrab || { msg_error 'missing dep: fbgrab'; return 3 ;}
        groups | grep -qw 'video' || { msg_error 'not in group: video'; return 3 ;}
        fbgrab "$_png" >/dev/null 2>&1 && printf '%s\n' "$_png"
    fi
)

tb() (
    is_bin nc || { command_not_found_handle nc; return $? ;}
    _url="$(cat "${1:-/dev/stdin}" | nc termbin.com 9999 | tr -d '\0')"
    [ -z "$_url" ] && { msg_error 'connection error'; return 3 ;}
    printf '%s\n' "$_url"
    [ -n "$DISPLAY" ] && is_bin xclip && printf '%s' "$_url" | xclip
)

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

thesaurus() (
    _dict="$ULIB/dict/mthesaur.txt"
    [ -f "$_dict" ] || { msg_error "$_dict: no such file" && return 3 ;}
    (($#)) || return
    grep "^$1," "$_dict" | sed 's/,/\n/g' | column
)

titleset() { [ -n "$1" ] && printf '\033]0;%s\007' "$*" ;}

uvim() {
    if [ -f "$UDIR/.user/.vim/.uvim" ]; then
        vim -c "source $UDIR/.user/.vim/.uvim" "$@"
    else
        vim "$@"
    fi
}

usudo() { command sudo -E env "PATH=$PATH" "$@" ;}

xclip() {
    [ -z "$DISPLAY" ] && { msg_error 'no display'; return 3 ;}
    command xclip -sel clipboard "$@"
}
xput() { xclip -o ;}
xyank() { xclip ;}

xreload() {
    [ -z "$DISPLAY" ] && { msg_error 'no display'; return 3 ;}
    [ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources"
}

# vim:ft=sh
