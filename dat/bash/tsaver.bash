#!/bin/bash

## tsaver.sh ::
# [unfinished]

print_help() {
printf '\e[0;38;5;15m'
cat <<'HELPDOC'
NAME
    tsaver.sh

SYNOPSIS
    tsaver.sh [OPTIONS]

DESCRIPTION
    Terminal screensaver. Output various random/not so random text to
    the terminal just for funzies.

OPTIONS
    -w, --wait <SECONDS>
        Wait time between characters. (default: 1)

    -p, --pause <SECONDS>
        Pause time between screens. (default: 8)

    -c, --colors <LIST>
        Terminal colors. (default: 3,9,10,11,12,13,14)

    -n, --num-colors <INTEGER|all>
        Number of colors for each screen. (default: all)

    --chars, --characters <STRING>
        Characters used. Passed to `tr -cd`. (default: 'A-Za-z0-9')

    -m, --mode <STRING>
        Pattern mode. (default: random-character)

    -H, --help
        Display this help.

MODES
    Each mode has various sub-options to alter its output.

    random-character, random
        Generate random characters.
HELPDOC
}

# command line options:
opt_wait=
opt_pause=
opt_colors=
opt_num=
opt_mode=
opt_chars=

# default options:
wait=1
wait_clear=0
pause=8
colors='10,12,13,14'
num='all'
mode='random-words'
chars='0-1'
wordlist='/usr/share/dict/usa'
wordfile="$UDIR/dat/text/Meditations.txt"

# internal control:
delimiter=' '
o=0
d=0
cols=1
lines=1
keypress=
text=
len=
screen=()
screen_clear=()
colors_arr=()
words=()

## functions ::
msg_error() {
	printf "\e[1;38;5;9m==> E: \e[0;38;5;15m$1\e[0m\n" "${@:2}" >&2
}

screen_init() {
    cols=$(tput cols)
    lines=$(tput lines)
    len=$((cols*lines))
    tput civis
}

screen_gen() {
    local color=${colors_arr[((RANDOM%${#colors_arr[@]}))]}
    local color_last=-1
    local w=0
    local c=0
    if [ "$mode" = 'random' ] || [ "$mode" = 'random-character' ]; then
        mapfile -t words < <(tr -cd "$chars" </dev/random | head -c $len | sed -E 's/(.)/\1\n/g')
        delimiter=''
    elif [ "$mode" = 'random-word' ] || [ "$mode" = 'random-words' ]; then
        #mapfile -t words < <(sed -E -e '/^ *#/d' -e '/^ *$/d' "$wordfile" | tr '\n' ' ' | \
            #sed -E -e 's/"//g' -e 's/[\.?!] +[A-Z][^ ]*//g' -e 's/  +/ /g' | tr ' ' '\n' | \
            #sed -E -e "s/[^A-Za-z0-9']//g" -e "/^'/d" -e "/'$/d" -e '/^.{0,2}$/d' | shuf)
        mapfile -t words < <(grep -P '^[a-z]{3,8}$' "$wordlist" | shuf)
    fi
    mapfile -t screen < <( \
        { while [ $c -lt $((lines*cols)) ]; do
            if [ ${#words[w]} -lt $((cols-c%cols+1)) ]; then
                printf '\033[%d;%df\e[1;38;5;%dm%s' $((c/cols+1)) $((c%cols+1)) $color "${words[w]}"
                c=$((c+${#words[w]}))
                if [ ${#delimiter} -le $((cols-c%cols)) ] && [ $((c%cols)) -ne 0 ]; then
                    printf '%s' "$delimiter"
                    c=$((c+${#delimiter}))
                fi
                printf '\n'
                color_last="$color"
                while [ "$color" = "$color_last" ] && [ ${#colors_arr[@]} -gt 1 ]; do
                    color=${colors_arr[((RANDOM%${#colors_arr[@]}))]}
                done
                ((w++))
            else
                c=$(((c/cols+1)*cols))
            fi
        done ;} | shuf)
}

screen_clear_gen() {
    mapfile -t screen_clear < <( \
        { for ((c=1;c<=cols;c++)); do
            for ((l=1;l<=lines;l++)); do
                printf '\033[%d;%df \n' $l $c
            done
        done ; } | sort -R )
}

screen_exit() {
    tput cnorm
    tput cup $lines $cols
    printf '\e[38;5;7m\n'
    exit 0
}

## main ::
if [ -f "$UDIR/dat/text/words.txt" ]; then
    wordlist="$UDIR/dat/text/words.txt"
fi

if [ ! -f "$wordlist" ]; then
    msg_error "wordlist not found: $wordlist"
    exit 1
fi
if [ ! -f "$wordfile" ]; then
    msg_error "wordfile not found: $wordfile"
    exit 1
fi

while (($#)); do
    case "$1" in
        -m|--mode)
            shift
            opt_mode="$1" ;;
        -c|--config)
            shift
            opt_config="$1" ;;
        -H|--help)
            print_help
            exit 0 ;;
        *)
            msg_error 'unknown option: %s' "$1"
            exit 4 ;;
    esac
    shift
done

mapfile -t -d ',' colors_arr < <(printf '%s' "$colors")
#mapfile -t -d ',' colors_arr <<<"$colors"

mode="${opt_mode:-$mode}"

trap "{ screen_init; screen_gen; flag_resize=true; }" WINCH
trap screen_exit HUP INT QUIT KILL

screen_init
screen_gen

while true; do
    flag_resize=false
    clear
    c=0
    while [ $c -lt ${#screen[@]} ] && [ "$flag_resize" = 'false' ]; do
        printf '%s' "${screen[c]}"
        if [ "$wait" != '0' ]; then
            sleep "$wait"
        fi
        ((c++))
    done
    if [ "$flag_resize" = 'false' ]; then
        screen_gen
        screen_clear_gen
        read -rsn1 -t "$pause"
    fi
    c=0
    while [ $c -lt ${#screen_clear[@]} ] && [ "$flag_resize" = 'false' ]; do
        printf '%s' "${screen_clear[c]}"
        if [ "$wait_clear" != '0' ]; then
            sleep "$wait_clear"
        fi
        ((c++))
    done
done

tsaver_exit

# vim:ft=bash
