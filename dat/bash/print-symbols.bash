#!/bin/bash

## print-symbols.bash ::
# [old] [unfinished]

print_help() {
cat  <<'HELPDOC'
NAME
    print-colors

SYNOPSIS
    print-symbols [OPTIONS]

DESCRIPTION
    Print symbols and their corresponding terminal escape codes.

OPTIONS
    -A, --ascii
        Print ASCII symbols and codes.

    -a, --all
        Display all characters and codes.

    -p, --printable
        Display printable characters and codes.

    -s, --symbols
        Display non-letter, non-number characters and codes.

    -U, --unicode
        Print Unicode symbols and codes.

    -H, --help
        Display this help.
HELPDOC
exit 0
}

dir_script="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# args:
args=( "$@" )
args_n=0
arg="${args[args_n]}"
# flags:
flag_ascii=false
flag_all=false
flag_print=false
flag_symbol=false
flag_unicode=false
# ascii:
ascii_nonprint_symbols=(NUL SOH STX ETX EOT ENQ ACK BEL
    BS HT LF VT FF CR SO SI DLE DC1 DC2 DC3 DC4
    NAK SYN ETB CAN EM SUB ESC FS GS RS US DEL)
ascii_nonprint_description=(
    'null character \0'
    'start of heading'
    'start of text'
    'end of text'
    'end of transmission'
    'enquiry'
    'acknowledge'
    'bell \a'
    'backspace \b'
    'horizontal tab \t'
    'new line \n'
    'vertical tab \v'
    'form feed \f'
    'carriage return \r'
    'shift out'
    'shift in'
    'data link escape'
    'device control 1'
    'device control 2'
    'device control 3'
    'device control 4'
    'negative acknowledge'
    'synchronous idle'
    'end of transmission block'
    'cancel'
    'end of medium'
    'substitute'
    'escape'
    'file separator'
    'group separator'
    'record separator'
    'unit separator'
    'delete')
ascii_nonprint_hexes=(00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
    10 11 12 13 14 15 16 17 18 19 1A 1B 1C 1D 1E 1F 7F)
ascii_symbol_hexes=(20 21 22 23 24 25 26 27 28 29 2A 2B 2C 2D 2E 2F
    3A 3B 3C 3D 3E 3F 40 5B 5C 5D 5E 5F 60 7B 7C 7D 7E)
ascii_number_hexes=(30 31 32 33 34 35 36 37 38 39)
ascii_uppercase_hexes=(41 42 43 44 45 46 47 48 49 4A 4B 4C 4D 4E 4F
    50 51 52 53 54 55 56 57 58 59 5A)
ascii_lowercase_hexes=(61 62 63 64 65 66 67 68 69 6A 6B 6C 6D 6E 6F
    70 71 72 73 74 75 76 77 78 79 7A)
# unicode:
unicode_all_hexes=(263A 263B 2665 2666 2663 2660 2022 25D8 25CB 25D9
    2642 2640 266A 266B 263C 25BA 25C4 2195 203C 00B6 00A7 25AC
    21A8 2191 2193 2192 2190 221F 2194 25B2 25BC 0020 0021 0022
    0023 0024 0025 0026 0027 0028 0029 002A 002B 002C 002D 002E
    002F 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 003A
    003B 003C 003D 003E 003F 0040 0041 0042 0043 0044 0045 0046
    0047 0048 0049 004A 004B 004C 004D 004E 004F 0050 0051 0052
    0053 0054 0055 0056 0057 0058 0059 005A 005B 005C 005D 005E
    005F 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 006A
    006B 006C 006D 006E 006F 0070 0071 0072 0073 0074 0075 0076
    0077 0078 0079 007A 007B 007C 007D 007E 2302 00C7 00FC 00E9
    00E2 00E4 00E0 00E5 00E7 00EA 00EB 00E8 00EF 00EE 00EC 00C4
    00C5 00C9 00E6 00C6 00F4 00F6 00F2 00FB 00F9 00FF 00D6 00DC
    00A2 00A3 00A5 20A7 0192 00E1 00ED 00F3 00FA 00F1 00D1 00AA
    00BA 00BF 2310 00AC 00BD 00BC 00A1 00AB 00BB 2591 2592 2593
    2502 2524 2561 2562 2556 2555 2563 2551 2557 255D 255C 255B
    2510 2514 2534 252C 251C 2500 253C 255E 255F 255A 2554 2569
    2566 2560 2550 256C 2567 2568 2564 2565 2559 2558 2552 2553
    256B 256A 2518 250C 2588 2584 258C 2590 2580 03B1 00DF 0393
    03C0 03A3 03C3 00B5 03C4 03A6 0398 03A9 03B4 221E 03C6 03B5
    2229 2261 00B1 2265 2264 2320 2321 00F7 2248 00B0 2219 00B7
    221A 207F 00B2 25A0)
unicode_all2_hexes=(263A 263B 2665 2666 2663 2660 2022 25D8 25CB 25D9
    2642 2640 266A 266B 263C 25BA 25C4 2195 203C 00B6 00A7 25AC
    21A8 2191 2193 2192 2190 221F 2194 25B2 25BC  2302 00C7 00FC 00E9
    00E2 00E4 00E0 00E5 00E7 00EA 00EB 00E8 00EF 00EE 00EC 00C4
    00C5 00C9 00E6 00C6 00F4 00F6 00F2 00FB 00F9 00FF 00D6 00DC
    00A2 00A3 00A5 20A7 0192 00E1 00ED 00F3 00FA 00F1 00D1 00AA
    00BA 00BF 2310 00AC 00BD 00BC 00A1 00AB 00BB  03B1 00DF 0393
    03C0 03A3 03C3 00B5 03C4 03A6 0398 03A9 03B4 221E 03C6 03B5
    2229 2261 00B1 2265 2264 2320 2321 00F7 2248 00B0 2219 00B7
    221A 207F 00B2 )
unicode_table1_hexes=(2500 2502 250C 2514 2510 2518
    252C 2534 251C 253C 2524)
unicode_table1_hexes=(2500 2502 250C 2510 2514 2518
    251C 2524 252C 2534 253C )
unicode_table2_hexes=(2550 2551 2554 255A 2557 255D
    2566 2569 2560 256C 2563)
unicode_table2_hexes=(2550 2551 2554 2557 255A 255D
    2560 2563 2566 2569 256C)
unicode_table1_2_hexes=(2552 2553 2555 2556 2558 2559 255B 255C
    255E 255F 2561 2562 2564 2565 2567 2568 256A 256B)
unicode_block_hexes=(
2588 2593 2592 2591
2580 2584 258C 2590
25A0
)
# colors:
c_black=$'\e[0;30m'
c_blue_b=$'\e[1;38;5;27m'
c_cyan_b=$'\e[1;36m'
c_green_b=$'\e[1;38;5;46m'
c_magenta_b=$'\e[1;35m'
c_red_b=$'\e[1;38;5;196m'
c_yellow_b=$'\e[1;33m'
c_white=$'\e[0;38;5;15m'
c_white_b=$'\e[1;37m'
c_gray=$'\e[0;37m'

msg() {
# print status message:
    printf '%s==>%s %s%s\n' "$c_green_b" "$c_white_b" "$1" "$c_gray"
}

# Print ASCII symbol and escape code for decimal $1 input.
print_symbol_ascii() {
    if [ -n "$1" ]; then
        if [ $1 -lt 32 ]; then
            printf "$c_white_b%-3s $c_gray \\\x%02X" \
                "${ascii_nonprint_symbols[$1]}" $1
        else
            printf "$c_white_b\x$(printf "%02X" \
                $1)$x_gray \\\x%02X" $1
        fi
    fi
    return 0
}

# Print Unicode symbol and escape code for decimal $1 input.
print_symbol_unicode() {
    if [ -n "$1" ]; then
        printf "$c_white_b\u$(printf "%X" \
            $1) $c_gray\\\u%X" $1
    fi
    return 0
}

# Print Unicode symbol and escape code for hex $1 input.
print_symbol_unicode_hex() {
    if [ -n "$1" ]; then
        printf "$c_white_b\u$1 $c_gray\\\u$1"
    fi
    return 0
}

# Print ASCII symbols.
ascii_print() {
    local n=0
    local m
    msg "ASCII codes:"
    # set table size:
    if [ "$flag_all" = true ]; then
        m=31
    elif [ "$flag_print" = true ]; then
        m=25
    else
        m=7
    fi
    while [ $n -le $m ]; do
        printf "  "
        # print non-printing codes:
        if [ "$flag_all" = true ]; then
            print_symbol_ascii $n
            printf "    "
        fi
        # print letters and numbers:
        if [ "$flag_print" = true ]; then
            if [ $n -le 25 ]; then
                print_symbol_ascii $((n+65))
                printf "    "
                print_symbol_ascii $((n+97))
            fi
            if [ $n -le 9 ]; then
                printf "    "
                print_symbol_ascii $((n+48))
                printf "    "
            fi
        fi
        # print symbols:
        if [ "$flag_symbol" = true ]; then
            if [ $n -le 7 ]; then
                print_symbol_ascii $((n+32))
            fi
            if [ $n -le 7 ]; then
                printf "    "
                print_symbol_ascii $((n+40))
            fi
            if [ $n -le 7 ]; then
                printf "    "
                if [ $n -le 6 ]; then
                    print_symbol_ascii $((n+58))
                else
                    print_symbol_ascii $((n+84))
                fi
            fi
            if [ $n -le 7 ]; then
                printf "    "
                if [ $n -le 4 ]; then
                    print_symbol_ascii $((n+92))
                else
                    print_symbol_ascii $((n+118))
                fi
            fi
            if [ $n -le 0 ]; then
                printf "    "
                print_symbol_ascii $((n+126))
            fi
        fi
        printf "\n"
        ((n++))
    done
    return 0
}

# Print Unicode symbols.
unicode_print() {
    #printf "${#unicode_all_hexes[@]}\n"
    #printf "${#unicode_table_hexes[@]}\n"
    local n=0
    local m=42
    local hex
    n=1
    for hex in "${unicode_all2_hexes[@]}"; do
        print_symbol_unicode_hex $hex
        if [ $((n % 8)) -eq 0 ]; then
            printf "\n"
        else
            printf "    "
        fi
        ((n++))
    done

    printf "\n"
    msg "Unicode codes:"

    n=0
    while [ $n -lt $m ]; do
        printf "  "
        # print symbols
        if [ "$flag_symbol" = true ]; then
            # table borders:
            if [ $n -lt 11 ]; then
                print_symbol_unicode_hex ${unicode_table1_hexes[n]}
            elif [ $n -lt 12 ]; then
                printf "        "
            elif [ $n -lt 23 ]; then
                print_symbol_unicode_hex \
                    ${unicode_table2_hexes[$((n-13))]}
            elif [ $n -lt 24 ]; then
                printf "        "
            elif [ $n -lt 42 ]; then
                print_symbol_unicode_hex \
                    ${unicode_table1_2_hexes[$((n-24))]}
            fi
            printf "    "
            # blocks:
            if [ $n -lt 9 ]; then
                print_symbol_unicode_hex ${unicode_block_hexes[n]}
            else
                printf "        "
            fi
            printf "    "


            # standard ascii symbols:
            if [ $n -le 15 ]; then
                print_symbol_unicode $((n+32))
            elif [ $n -le 22 ]; then
                print_symbol_unicode $((n+42))
            elif [ $n -le 29 ]; then
                print_symbol_unicode $((n+68))
            elif [ $n -le 32 ]; then
                print_symbol_unicode $((n+94))
            else
                printf "        "
            fi
            printf "    "
        fi
        # letters and numbers:
        if [ "$flag_print" = true ]; then
            if [ $n -le 25 ]; then
                print_symbol_unicode $((n+65))
                printf "    "
                print_symbol_unicode $((n+97))
            fi
            if [ $n -le 9 ]; then
                printf "    "
                print_symbol_unicode $((n+48))
                printf "    "
            fi
        fi

        printf "\n"
        ((n++))
    done
    return 0
}

# parse args:
while [ -n "$arg" ]; do case "$arg" in
    # flag args:
    -A|--ascii)
        flag_ascii=true
        arg="${args[((++args_n))]}" ;;
    -U|--unicode)
        flag_unicode=true
        arg="${args[((++args_n))]}" ;;
    -a|--all)
        flag_all=true
        arg="${args[((++args_n))]}" ;;
    -p|--printable|--print)
        flag_print=true
        arg="${args[((++args_n))]}" ;;
    -s|--symbols|--symbol)
        flag_symbol=true
        arg="${args[((++args_n))]}" ;;
    # help:
    -H|--help|-h)
        print_help ;;
    # all flag args:
    -[AUapsHh]*)
        # all args:
        if [[ ${arg:2:1} =~ [AUapsHh] ]]; then
            args[((args_n--))]="-${arg:2}"
            arg="${arg:0:2}"
        else
            printf "error: unrecognized option: ${arg:2:1}\n"
            return 1
        fi ;;
    *)
        break ;;
esac; done

# set print flags:
if [ "$flag_ascii" = false ] && [ "$flag_unicode" = false ]; then
    flag_ascii=true
fi
if [ "$flag_all" = true ]; then
    flag_print=true
    flag_symbol=true
elif [ "$flag_print" = true ]; then
    flag_symbol=true
else
    flag_symbol=true
fi

# call print function:
if [ "$flag_ascii" = true ]; then
    ascii_print
fi
if [ "$flag_unicode" = true ]; then
    unicode_print
fi

exit 0

print_utf_tables() {
    local lst_utf_1="263A 263B 2665 2666 2663 2660 2022 25D8 25CB 25D9 2642 2640 266A 266B 263C 25BA 25C4 2195 203C 00B6 00A7 25AC 21A8 2191 2193 2192 2190 221F 2194 25B2 25BC 2302"
    local lst_utf_2="00C7 00FC 00E9 00E2 00E4 00E0 00E5 00E7 00EA 00EB 00E8 00EF 00EE 00EC 00C4 00C5 00C9 00E6 00C6 00F4 00F6 00F2 00FB 00F9 00FF 00D6 00DC 00A2 00A3 00A5 20A7 0192 00E1 00ED 00F3 00FA 00F1 00D1"
    local lst_utf_3="00AA 00BA 00BF 2310 00AC 00BD 00BC 00A1 00AB 00BB"
    local lst_utf_4="2591 2592 2593  2588 2584 258C 2590 2580 25A0"
    local lst_utf_5="2502 2524 2561 2562 2556 2555 2563 2551 2557 255D 255C 255B 2510 2514 2534 252C 251C 2500 253C 255E 255F 255A 2554 2569 2566 2560 2550 256C 2567 2568 2564 2565 2559 2558 2552 2553 256B 256A 2518 250C"
    local lst_utf_6="03B1 00DF 0393 03C0 03A3 03C3 00B5 03C4 03A6 0398 03A9 03B4 221E 03C6 03B5 2229      2261 00B1 2265 2264 2320 2321 00F7 2248 00B0 2219 00B7 221A 207F 00B2"
    local lst_utf_7="0021 0022 0023 0024 0025 0026 0027 0028 0029 002A 002B 002C 002D 002E 002F 003A 003B 003C 003D 003E 003F 0040 005B 005C 005D 005E 005F 0060 007B 007C 007D 007E"
    local lst_utf_8="0030 0031 0032 0033 0034 0035 0036 0037 0038 0039"
}

# vim:ft=bash
