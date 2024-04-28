#!/bin/sh
## ~/.profile ::

## user setup: UDIR, UHOST, upwd() ::
export UDIR="$HOME/user"
export HOME_REALPATH="$(realpath "$HOME")"
export UDIR_REALPATH="$(realpath "$UDIR")"
UHOST="$HOSTNAME"
[ -f '/etc/hostname' ] && UHOST="$(cat /etc/hostname)"
[ -f '/etc/hostname-' ] && UHOST="$(cat /etc/hostname-)"
export UHOST

upwd() {
    PWD_REALPATH="$(realpath "$PWD")"
    case "$PWD" in
        "$UDIR"*) printf '%s' "-${PWD#"$UDIR"}" ;;
        "$UDIR_REALPATH"*) printf '%s' "-${PWD#"$UDIR_REALPATH"}" ;;
        "$HOME"*) printf '%s' "~${PWD#"$HOME"}" ;;
        "$HOME_REALPATH"*) printf '%s' "~${PWD_REALPATH#"$HOME_REALPATH"}" ;;
        *) case "$PWD_REALPATH" in
            "$UDIR"*) printf '%s' "-${PWD_REALPATH#"$UDIR"}" ;;
            "$UDIR_REALPATH"*) printf '%s' "-${PWD_REALPATH#"$UDIR_REALPATH"}" ;;
            "$HOME"*) printf '%s' "~${PWD_REALPATH#"$HOME"}" ;;
            "$HOME_REALPATH"*) printf '%s' "~${PWD_REALPATH#"$HOME_REALPATH"}" ;;
            *) printf '%s' "$PWD" ;;
        esac ;;
    esac
}

## utils ::
is_bin() (
    [ -z "$1" ] && return 1
    IFS=':'
    for dir in $PATH; do [ -f "$dir/$1" ] && [ -x "$dir/$1" ] && return 0; done
    return 1
)

path_add() {
    case ":$PATH:" in
        *:"$1":*) ;;
        *) export PATH="$1${PATH:+:$PATH}" ;;
    esac
}

## path ::
path_add "$HOME/.local/bin"
path_add "$UDIR/bin"
path_add "$UDIR/local/bin"
path_add "$HOME/bin"

## environment ::
export PS1='\[\e[0;38;5;6m\]$UHOST\[\e[1;38;5;10m\]:\[\e[38;5;12m\]$(upwd)\[\e[38;5;10m\]\$\[\e[0m\] '
export PS2='\[\e[0m\] '

[ -d "$UDIR/lib/python" ] && export PYTHONPATH="$UDIR/lib/python"
[ -f "$UDIR/.user/.pythonrc" ] && export PYTHONSTARTUP="$UDIR/.user/.pythonrc"

[ -d "$UDIR/lib/figlet" ] && export FIGLET_FONTDIR="$UDIR/lib/figlet"

is_bin gpg && gpg --list-secret-keys '4742C8240A64DA01' >/dev/null 2>&1 && export GPGKEY='4742C8240A64DA01'

export SUDO_PROMPT="$(printf '\e[1;38;5;9m:> \e[0;38;5;15mpassword: \e[0m')"
su() { printf '\e[1;38;5;9m:> \e[0;38;5;15m'; command su "$@" ;}

command_not_found_handle() {
    printf '\e[1;38;5;11mC:\e[0;38;5;15m %s\e[0m\n' "$1"; return 127
}

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

if [ -f "$HOME/.lscolors" ]; then
    eval "$(dircolors "$HOME/.lscolors")"
else
    eval "$(dircolors)"
fi

export GREP_COLORS='mt=38;5;3:mc=48;5;3;38;5;0:fn=38;5;14:ln=38;5;8:bn=38;5;4:se=1;38;5;5'

export GROFF_NO_SGR=

is_bin fzf && [ -f "$HOME/.config/fzf/profile.sh" ] && . "$HOME/.config/fzf/profile.sh"

export HISTSIZE=4096
export HISTFILESIZE=4096
export HISTCONTROL='ignoredups:ignorespace:erasedups'
export HISTIGNORE='cd[dgilmpst./-]:cdtt*:bg:builtin cd*:fg:exit:poweroff:reboot:startx'
export CDHISTSIZE=16

export JQ_COLORS='0;38;5;6:0;38;5;11:0;38;5;11:0;38;5;3:0;38;5;10:0;38;5;13:0;38;5;13:0;38;5;12'

LESS='-i -x4 -M -R -~ --mouse --wheel-lines=4 --intr=q$ -PM ?f%f:[stdin]. ?m(%i/%m) .| %L lines | ?eBot:%Pb\%. | %lt-%lb $'
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
export LESS

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

if is_bin ffmpeg; then
    ffmpeg() { command ffmpeg -hide_banner "$@" ;}
    is_bin ffplay && ffplay() { command ffplay -hide_banner "$@" ;}
    is_bin ffprobe && ffprobe() { command ffprobe -hide_banner "$@" ;}
fi

grep() { command grep --color=auto "$@" ;}

is_bin gpg && gpg() { command gpg --no-greeting -q "$@" ;}

ip() { command ip -color=auto "$@" ;}

lls() { ls --color=always | less -R ;}
ls() { LANG=C command ls -ALh --color=auto --group-directories-first "$@" ;}
ls1() { ls -1 "$@" ;}
lsl() { ls -l "$@" ;}
lss() { ls -s "$@" ;}

lsblk() {
    if printf '%s\n' "$@" | grep -Fxq -- '-O'; then
        LANG=C command lsblk "$@"
    else
        LANG=C command lsblk -o NAME,FSTYPE,SIZE,FSUSED,MOUNTPOINTS "$@"
    fi
}

is_bin minicom && minicom() { command minicom -F ' /dev/%D | %T | %C ' "$@" ;}

is_bin pactree && pactree() { command pactree -a "$@" ;}

is_bin ranger && ranger() {
    command ranger --choosedir="$TMPDIR/rangerdir.txt" "$@"
    cd "$(cat $TMPDIR/rangerdir.txt)"
}

reset() { tput reset ;}

is_bin stylelint && stylelint() { command stylelint -f unix -c ~/.stylelintrc.yml "$@" ;}

is_bin tmux && tmux() { command tmux -2 "$@" ;}

is_bin tt && tt() { command tt -notheme -noskip -blockcursor -nohighlight "$@" ;}

is_bin vim && [ "$TERM" = 'linux' ] && vim() { TERM='linux-16color' command vim "$@" ;}

is_bin zathura && zathura() { command zathura --fork "$@" ;}

## functions: commands ::
calc() {
    printf 'scale=3;%s\n' "$*" | bc -l
}

cdtt() {
    d=1
    while [ -e "$TMPDIR/tmp$d" ]; do
        d=$((d+1))
    done
    mkdir "$TMPDIR/tmp$d"
    [ -n "$1" ] && cp -r "$@" "$TMPDIR/tmp$d"
    cd "$TMPDIR/tmp$d"
    unset d
}

if is_bin gpgconf; then
    gpgreset() {
        gpgconf --kill gpg-agent
    }
fi

reload() {
    . "$HOME/.profile"
}

if [ -n "$DISPLAY" ] && is_bin import; then
    screenshot() (
        png_screen="/tmp/screen_$(date +'%F_%H-%M-%S').png"
        import -window root "$png_screen" && printf '%s\n' "$png_screen"
    )
elif [ -z "$DISPLAY" ] && is_bin fbgrab && groups | grep -q '\bvideo\b'; then
    screenshot() (
        png_screen="/tmp/screen_$(date +'%F_%H-%M-%S').png"
        fbgrab "$png_screen" >/dev/null 2>&1 && printf '%s\n' "$png_screen"
    )
fi

if is_bin nc; then
    tb() (
        url=
        if [ -n "$1" ]; then
            url="$(cat "$@" | nc termbin.com 9999 | tr -d '\0')"
        else
            url="$(nc termbin.com 9999 | tr -d '\0')"
        fi
        if [ -z "$url" ]; then
            return 1
        fi
        printf '%s\n' "$url"
        if [ -n "$DISPLAY" ] && is_bin xclip; then
            printf '%s' "$url" | xclip
        fi
    )
fi

tempcp() {
    mkdir -p "$TMPDIR/temp"
    find "$UDIR/dat" -maxdepth 2 -regex '.*/temp\.[a-z]*' | while IFS= read -r temp; do
        cp "$temp" "$TMPDIR/temp"
    done
}

termset() {
    if [ "$TERM" = 'linux' ] || [ "$TERM" = 'linux-16color' ]; then
        if [ -f "$HOME/.cache/wal/colors-tty.sh" ]; then
            sh "$HOME/.cache/wal/colors-tty.sh"
        elif [ -f "$UDIR/.user/.cache/wal/colors-tty.sh" ]; then
            sh "$UDIR/.user/.cache/wal/colors-tty.sh"
        else
            return 1
        fi
    elif [ -z "$TMUX" ]; then
        if [ -f "$HOME/.cache/wal/sequences" ]; then
            cat "$HOME/.cache/wal/sequences"
        elif [ -f "$UDIR/.user/.cache/wal/sequences" ]; then
            cat "$UDIR/.user/.cache/wal/sequences"
        else
            return 1
        fi
    else
        return 1
    fi
}

titleset() {
    [ -n "$1" ] && printf '\033]0;%s\007' "$*"
}

uvim() {
    ! is_bin vim && exit 127
    if [ -f "$UDIR/.user/.vim/.uvim" ]; then
        vim -c "source $UDIR/.user/.vim/.uvim" "$@"
    else
        vim "$@"
    fi
}

if [ -n "$DISPLAY" ] && is_bin xclip; then
    xclip() {
        command xclip -sel clipboard "$@"
    }
    xyank() {
        xclip
    }
    xput() {
        xclip -o
    }
fi

# vim:ft=sh
