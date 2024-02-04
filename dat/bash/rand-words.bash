#!/bin/bash

## rand-words.bash ::
# Print some random words.

## config ::
dict='/usr/share/dict/words'
n_words=24
n_pars=8

## internal ::
text=''
n_word=0

msg_error() {
	printf "\e[1;38;5;9m==> E: \e[0;38;5;15m$1\e[0m\n" "${@:2}" >&2
}

## main ::
if [ -f "$UDIR/dat/text/words.txt" ]; then
    dict="$UDIR/dat/text/words.txt"
elif [ ! -f "$dict" ]; then
    msg_error 'dictionary not found: %s' "$dict"
fi

mapfile -t rwords < <(sed -E '/^[a-z]{3,6}$/!d' "$dict" | sort -R)

for ((p=0; p<n_pars; p++)); do
    text="${rwords[((n_word++))]}"
    for ((w=1; w<n_words; w++)); do
        text="$text ${rwords[((n_word++))]}"
    done
    printf '%s\n\n' "$text"
done

# vim:ft=bash
