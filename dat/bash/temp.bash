#!/bin/bash
## temp.bash ::
# shellcheck disable=SC2034

[[ $0 != "${BASH_SOURCE[0]}" ]] && return 0
print_help() { cat <<'HELPDOC'
Usage:
  temp.bash [option...] [arg...]

Bash template script and function library.

Options:
  -l, --list <arg>      append to list
  -v, --var <arg>       variable
  -M, --nocolor         disable colored output
  -Q, --quiet           print nothing to stdout
  -V, --verbose         print more verbose information
  -H, -h, --help        print help and exit

Format:
  %%    a literal %
  %S    script full path
  %s    script basename

Environment:
  NO_COLOR      disable colored output
  QUIET         run silently
  VERBOSE       run verbosely
HELPDOC
exit ;}
[[ $1 =~ ^(-H|-h|--help)$ ]] && print_help

## settings ::
debug=0; dryrun=0; no_color=0; quiet=0; verbose=0

## internal functions/variables ::
readonly -a args=("$@")
readonly -a deps=(curl)
readonly -a opts=(-l: --list: -v: --var: -H -h --help -M --nocolor -Q --quiet -V --verbose)
readonly path_script="$(realpath "$BASH_SOURCE")"
readonly script="$(basename "$BASH_SOURCE")"
unset var
args_options=() args_positionals=()
formats=("S:$path_script" "s:$script")
list=()

# colors:
black=$'\e[38;5;0m'; blue=$'\e[38;5;12m'; cyan=$'\e[38;5;14m'
green=$'\e[38;5;10m'; grey=$'\e[38;5;8m'; magenta=$'\e[38;5;13m'
orange=$'\e[38;5;3m'; red=$'\e[38;5;9m' white=$'\e[38;5;15m'
yellow=$'\e[38;5;11m'; bold=$'\e[1m'; off=$'\e[0m'
clear_colors() {
    export NO_COLOR=true; nocolor=1
    unset black blue cyan green grey magenta orange red white yellow bold off
}

# messages:
msg() { printf "$bold$blue=> $off$white%s$off\n" "$*" ;}
msg2() { printf "$bold$blue > $off$white%s$off\n" "$*" ;}
msg_error() { printf "$bold${red}E: $off$white%s$off\n" "$*" >&2 ;}
msg_good() { printf "$bold$green=> $off$white%s$off\n" "$*" ;}
msg_plain() { printf "$off$white  %s$$off\n" "$*" ;}
msg_warn() { printf "$bold${yellow}W: $off$white%s$off\n" "$*" >&2 ;}
msg_cmd() {
    local _printf='printf'; [[ -f /usr/bin/printf ]] && _printf='/usr/bin/printf'
    [[ $EUID -eq 0 ]] && printf "$bold$red #" || printf "$bold$blue $"
    printf "$off$white"; "$_printf" ' %q' "$@"; printf "$off\n"
}

# utils:
check_deps() {
    # Check dependencies, return number missing (O if no error).
    # Input:
    #   deps -- array of dependencies
    # Usage:
    #   deps=(cmd1 cmd2 cmd3)
    #   check_deps || exit
    local deps_e=()
    for dep in "${deps[@]}"; do is_cmd "$dep" || deps_e+=("$dep"); done
    [[ ${#deps_e} -gt 0 ]] && msg_error "missing deps: ${deps_e[*]}"
    return ${#deps_e[@]}
}
is_cmd() { command -v "$1" &>/dev/null ;}
is_img() { [[ -f $1 ]] && identify "$1" &>/dev/null ;}
is_port() { [[ $1 =~ ^[1-9][0-9]*$ && $1 -lt 65536 ]] ;}

parse_args() {
    # Parse command line options, separate options, return 3 if error.
    # Inputs:
    #   args -- array of command line arguments
    #   opts -- array of valid options; options with a color require arguments
    # Outputs:
    #   args_options -- array of parsed, separated options and option arguments
    #   args_positionals -- array of positional arguments
    # Usage:
    #   args=("$@"); opts=(-f --for -b: --bar: help)
    #   parse_args || exit
    #   set -- "${args_options[@]}"
    #   while [[ -n $1 ]]; do case "$1" in ... esac; shift; done
    local a=0 opt= sflgs= sopts= arg="${args[0]}"
    local -a lflgs=() lopts=()
    args_options=() args_positionals=()
    bad_opt() { msg_error "unrecognized option: -${arg:2:1}" ;}
    bad_optarg() { msg_error "option requires an argument: $arg" ;}
    bad_flg() { msg_error "option does not take argument: ${arg%%=*}" ;}
    for opt in "${opts[@]}"; do case "$opt" in
        -?) sflgs="$sflgs${opt:1}" ;;
        -?:) sopts="$sopts${opt:1:1}" ;;
        *:) lopts+=("${opt:0:-1}") ;;
        *) lflgs+=("$opt") ;;
    esac; done
    while [[ -n $arg ]]; do case "$arg" in
        --) ((a++)); break ;;
        -[$sflgs]) args_options+=("$arg") ;;
        -[$sflgs]*) [[ ! $sflgs$sopts =~ ${arg:2:1} ]] && { bad_opt; return 3 ;}
            args_options+=("${arg:0:2}"); arg="-${arg:2}"; continue ;;
        -[$sopts]) [[ $((${#args[@]}-a)) -le 1 ]] && { bad_optarg; return 3 ;}
            args_options+=("$arg" "${args[((++a))]}") ;;
        -[$sopts]*) args_options+=("${arg:0:2}" "${arg:2}") ;;
        *=*) [[ " ${lflgs[*]} " =~ " ${arg%%=*} " ]] && { bad_flg; return 3 ;}
            [[ " ${lopts[*]} " =~ " ${arg%%=*} " ]] || break
            args_options+=("${arg%%=*}" "${arg#*=}") ;;
        *) if [[ " ${lflgs[*]} " =~ " $arg " ]]; then
                args_options+=("$arg")
            elif [[ " ${lopts[*]} " =~ " $arg " ]]; then
                [[ ${#args[@]} -le $((a+1)) ]] && { bad_optarg; return 3 ;}
                args_options+=("$arg" "${args[((++a))]}")
            else break; fi ;;
    esac; arg="${args[((++a))]}"; done
    args_positionals=("${args[@]:a}")
}

parse_arr() {
    # Parse array, remove dupes, optionally clear array at empty entries.
    # Input:
    #   $1 -- if set to clear, clear array at empty entires
    #   arr -- array
    # Output:
    #   arr_new -- parsed array
    # Usage:
    #   arr=(1 2 3 2 4)
    #   parse_arr; printf "${arr_new[*]}"
    local dup=0
    arr_new=()
    for a in "${arr[@]}"; do dup=0
        [[ -z $a && $1 == clear ]] && { arr_new=(); continue ;}
        for b in "${arr_new[@]}"; do [[ $a == $b ]] && { dup=1; break ;}; done
        ((dup)) || arr_new+=("$a")
    done
}

parse_yaml() {
    # Parse basic single level yaml text, return 3 if error.
    # Input:
    #   yaml -- yaml text
    # Output:
    #   yaml_* -- [array variable created for every valid yaml key]
    # Usage:
    #   yaml="$(<conf.yml)"
    #   parse_yaml || exit
    #   echo "value: $yaml_value"
    # TODO: multi-level yaml, quoted strings, more documentation
    local key= arr=() line= a=0
    mapfile -t arr <<<"$yaml"; line="${arr[0]}"
    while [[ -n $line || $a -lt ${#arr[@]} ]]; do
        if [[ $line =~ ^([A-Za-z][A-Za-z0-9_]*):\ *(.*) ]]; then
            key="yaml_${BASH_REMATCH[1]}"; declare -ga "$key"='()'
            if [[ -n ${BASH_REMATCH[2]} ]]; then
                line="- ${BASH_REMATCH[2]}"; continue
            fi
        elif [[ $line =~ ^-\ +(.*) && -n $key ]]; then
            declare -ga "$key"+='("${BASH_REMATCH[1]}")'
        elif [[ ! $line =~ ^\ *(#|$) ]]; then
            msg_error "yaml error: $line"; return 3
        fi; line="${arr[((++a))]}"
    done
}

sub_text() {
    # Format text containing %char sequences, return 3 if error.
    # Inputs:
    #   text -- format string
    #   subs -- array of char:replacement pairs
    # Output:
    #   text_subbed -- formatted text
    # Usage:
    #   subs=(n:name v:value); text='%n : %v'
    #   sub_text || exit
    #   echo "$text_subbed"
    # TODO: printf style padding options?
    local i=0 found=0 repl= sub=
    text_subbed=
    for sub in "${subs[@]}"; do
        [[ ${sub:1:1} == : ]] || { msg_error "invalid sub: $sub"; return 3 ;}
    done
    while [[ $i -lt ${#text} ]]; do
        repl="${text:i:1}"
        if [[ ${text:i:1} == % ]]; then
            ((i++))
            if [[ ${text:i:1} == % ]]; then
                repl='%'
            else
                found=0; for sub in "${subs[@]}"; do
                    if [[ ${text:i:1} == ${sub:0:1} ]]; then
                        repl="${sub:2}"; ((found++))
                fi; done
                if ! ((found)); then
                    msg_error "invalid format character: ${text:i:1}"
                    return 3
                fi
                ((found)) || { msg_error "invalid format: ${text:i:1}"; return 3 ;}
        fi; fi
        text_subbed+="$repl"; ((i++))
    done
}

# error, exit, trap:
error() { msg_error "$*"; exit 3 ;}
trap_exit() { ((debug)) && msg_error '[exit]' ;}
trap_int() { printf '\n'; msg_error '[sigint]'; exit 99 ;}

## main ::
trap trap_int INT
trap trap_exit EXIT

# set from env:
[[ -n $DEBUG ]] && debug=1
[[ -n $NO_COLOR || ! -t 1 || ! -t 2 ]] && { no_color=1; clear_colors ;}
[[ -n $QUIET ]] && { quiet=1; verbose=0 ;}
[[ -n $VERBOSE ]] && { quiet=0; verbose=1 ;}

# parse args:
parse_args || exit
set -- "${args_options[@]}"
while [[ -n $1 ]]; do case "$1" in
    -l|--list) shift; list+=("$1") ;;
    -v|--var) shift; var="$1" ;;
    -Q|--quiet) quiet=1; verbose=0 ;;
    -V|--verbose) quiet=0; verbose=1 ;;
    -M|--nocolor) no_color=1; clear_colors ;;
    -h|-H|--help) print_help ;;
esac; shift; done

# check for errors:
check_deps || exit

# parse yaml:
file="$HOME/user/dat/conf/simple.yaml"
if [[ -f $file ]]; then
    yaml="$(<"$file")"
    if parse_yaml && ! ((quiet)); then
        msg "yaml parsed: $file"
        printf -v arr '%s, ' "${yaml_list[@]}"; arr="${a:0:-2}"
        msg2 "copy: $yaml_copy"
        msg2 "dest: $yaml_dest"
        msg2 "list: [$arr]"
    fi
else
    msg_error "file not found: $file"
fi

# variable checks:
[[ -z ${var+x} ]] && msg "var is not set"
[[ -n ${var+x} && -z $var ]] && msg "var is set and empty"

# prompt for user input:
if [[ -z ${var+x} ]]; then
    read -erp "$green$bold> $off${white}var: $off" var
fi

# print args:
if ! ((quiet)); then
    msg2 "list: (${list[*]})"
    msg2 "pargs: (${args_positionals[*]})"
    msg2 "var: $var"
fi

formats+=(a:action d:dir p:path)
text='01_%d-%a_%%_%p_%s-%S'
format_text || exit
msg "$text -> $text_formatted"

# vim:ft=bash
