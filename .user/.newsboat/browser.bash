#!/bin/bash
## ~/.newsboat/browser.bash ::

print_help() { cat <<'HELPDOC'
NAME
    browser.bash - newsboat link handler

SYNOPSIS
    browser.bash <type> -- <url> -- <title>

DESCRIPTION
    This is script is a link handler for newsboat.

    To use, add the following to newsboat config:
        browser "browser.bash %t -- %u -- %T"
HELPDOC
}
[[ $0 != "${BASH_SOURCE[0]}" ]] && { print_help; return 0 ;}
[[ $1 =~ ^(-H|--help)$ ]] && { print_help; exit ;}

## settings ::
dir_in="${TMPDIR:-/tmp}"

## internal functions/variables ::
readonly -a cmd_iconv=(iconv -f utf-8 -t ascii//TRANSLIT)
readonly -a cmd_sed=(sed -Ee 's/&/and/g' -e 's/--+/-/g' -e 's/[^A-Za-z0-9: -]//g')
readonly -a deps=(iconv qutebrowser vim w3m)
args=() file= title= type= url=

## main ::
for d in "${deps[@]}"; do command -v "$d" &>/dev/null || exit; done

mapfile -t args < <(sed 's/ -- /\n/g' <<<"$*")
type="${args[0]}"; url="${args[1]}"; title="${args[2]}"

if [[ $type == article ]]; then
    mkdir -p "$dir_in"
    file="$dir_in/$("${cmd_iconv[@]}" <<<"${args[2]}" | "${cmd_sed[@]}").txt"
    { w3m -dump -cols $((COLUMNS-8)) "$url" | "${cmd_iconv[@]}"
    printf '\n# vim:ft=news\n' ;} > "$file"
    vim "$file"
elif [[ -z $DISPLAY ]] || [[ $type == w3m ]]; then
    w3m "$url"
else
    qutebrowser "$url" &>>/tmp/qutebrowser.log &
fi

# vim:ft=bash
