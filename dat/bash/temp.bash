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
  -o, --option <arg>    set value
  -M, --nocolor         disable colored output
  -Q, --quiet           print nothing to stdout
  -V, --verbose         print more verbose information
  -H, --help            print help and exit

Format:
  %%    a literal %
  %S    script full path
  %s    script basename

Environment:
  NO_COLOR      disable colored output
  QUIET         run silently
  VERBOSE       run verbosely
HELPDOC
exit "${1:-0}" ;}; [[ $1 =~ ^(-H|--help)$ ]] && print_help

## settings ::
debug=0 nocolor=0 quiet=0 verbose=0

## internal functions/variables ::
readonly -a args=("$@"); args_options=() args_positionals=()
readonly -a deps=(curl identify)
readonly -a opts=(-l: --list: -o: --option: -M --nocolor -Q --quiet -V --verbose -H --help)
readonly path_script="$(realpath "$BASH_SOURCE")"
readonly script="$(basename "$BASH_SOURCE")"
formats=("S:$path_script" "s:$script")
list=()
unset option

# colors:
black=$'\e[38;5;0m' blue=$'\e[38;5;12m' cyan=$'\e[38;5;14m' green=$'\e[38;5;10m'
grey=$'\e[38;5;8m' magenta=$'\e[38;5;13m' orange=$'\e[38;5;3m' red=$'\e[38;5;9m'
white=$'\e[38;5;15m' yellow=$'\e[38;5;11m' bold=$'\e[1m' off=$'\e[0m'
clear_colors() {
    export NO_COLOR=1 nocolor=1
    unset black blue cyan green grey magenta orange red white yellow bold off
}

# messages:
bin_printf() { printf "$@" ;}
[[ -f /usr/bin/printf ]] && bin_printf() { /usr/bin/printf "$@" ;}
msg() { printf "$bold$blue=> $off$white%s$off\n" "$*" ;}
msg2() { printf "$bold$blue > $off$white%s$off\n" "$*" ;}
msg_error() { printf "$bold${red}E: $off$white%s$off\n" "$*" >&2 ;}
msg_good() { printf "$bold$green=> $off$white%s$off\n" "$*" ;}
msg_plain() { printf "$off$white  %s$off\n" "$*" ;}
msg_warn() { printf "$bold${yellow}W: $off$white%s$off\n" "$*" >&2 ;}
msg_cmd() { [[ $EUID -eq 0 ]] && printf "$bold$red:#" || printf "$bold$blue:$"
    printf "$off$white"; bin_printf ' %q' "$@"; printf "$off\n" ;}

# utils:
check_deps() {
    # Check dependencies, return number missing (O if no error).
    # Input:
    #   $@ -- list of dependencies
    #   deps -- array of dependencies (used if $@ is empty)
    # Usage:
    #   deps=(cmd1 cmd2 cmd3)
    #   check_deps || exit
    local _dep= _errs=() _deps=("${deps[@]}"); [[ -n $1 ]] && _deps=("$@")
    for _dep in "${_deps[@]}"; do is_cmd "$_dep" || _errs+=("$_dep"); done
    ((${#_errs[@]})) && msg_error "missing deps: ${_errs[*]}"
    return ${#_errs[@]}
}
check_internet() { ping -q -c1 -W2 google.com &>/dev/null ;}
is_cmd() { command -v "$1" &>/dev/null ;}
is_img() { [[ -f $1 ]] && identify "$1" &>/dev/null ;}
is_port() { [[ $1 =~ ^[1-9][0-9]*$ && $1 -lt 65536 ]] ;}

parse_args() {
    # Parse command line options, separate options, return 3 if error.
    # Input:
    #   args -- array of command line arguments
    #   opts -- array of valid options; options with colon require arguments
    # Output:
    #   args_options -- array of parsed, separated options and option arguments
    #   args_positionals -- array of positional arguments
    # Usage:
    #   args=("$@") opts=(-f --foo -b: --bar: --help)
    #   parse_args || exit
    #   set -- "${args_options[@]}"
    #   while [[ -n $1 ]]; do case "$1" in ... esac; shift; done
    local _a=0 _opt= _sflgs= _sopts= _arg="${args[0]}"
    local -a _lflgs=() _lopts=()
    args_options=() args_positionals=()
    _eopt() { msg_error "unrecognized option: -${_arg:2:1}" ;}
    _eoptarg() { msg_error "option requires an argument: $_arg" ;}
    _eflg() { msg_error "option does not take argument: ${_arg%%=*}" ;}
    for _opt in "${opts[@]}"; do case "$_opt" in
        -?) _sflgs="$_sflgs${_opt:1}" ;;
        -?:) _sopts="$_sopts${_opt:1:1}" ;;
        *:) _lopts+=("${_opt:0:-1}") ;;
        *) _lflgs+=("$_opt") ;;
    esac; done
    while [[ -n $_arg ]]; do case "$_arg" in
        --) ((_a++)); break ;;
        -[$_sflgs]) args_options+=("$_arg") ;;
        -[$_sflgs]*) [[ ! $_sflgs$_sopts =~ ${_arg:2:1} ]] && { _eopt; return 3 ;}
            args_options+=("${_arg:0:2}") _arg="-${_arg:2}"; continue ;;
        -[$_sopts]) [[ $((${#args[@]}-_a)) -le 1 ]] && { _eoptarg; return 3 ;}
            args_options+=("$_arg" "${args[((++_a))]}") ;;
        -[$_sopts]*) args_options+=("${_arg:0:2}" "${_arg:2}") ;;
        *=*) [[ " ${_lflgs[*]} " =~ " ${_arg%%=*} " ]] && { _eflg; return 3 ;}
            [[ " ${_lopts[*]} " =~ " ${_arg%%=*} " ]] || break
            args_options+=("${_arg%%=*}" "${_arg#*=}") ;;
        *) if [[ " ${_lflgs[*]} " =~ " $_arg " ]]; then
                args_options+=("$_arg")
            elif [[ " ${_lopts[*]} " =~ " $_arg " ]]; then
                [[ ${#args[@]} -le $((_a+1)) ]] && { _eoptarg; return 3 ;}
                args_options+=("$_arg" "${args[((++_a))]}")
            else break; fi ;;
    esac; _arg="${args[((++_a))]}"; done
    args_positionals=("${args[@]:_a}")
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
    local _a= _b= _dup=0
    arr_new=()
    for _a in "${arr[@]}"; do _dup=0
        [[ -z $_a && $1 == clear ]] && { arr_new=(); continue ;}
        for _b in "${arr_new[@]}"; do [[ $_a == $_b ]] && { _dup=1; break ;}; done
        ((_dup)) || arr_new+=("$_a")
    done
}

parse_path() {
    # Parse path into directory, basename, name, extension.
    # Input:
    #   $1 -- path string to parse
    #   path -- path string to parse (used if $1 is empty)
    # Output:
    #   path_basename -- path_name + path_ext
    #   path_dir -- dir containing path, ends with /, empty if current dir
    #   path_ext -- path extension
    #   path_name -- path without directory and/or extension
    # Usage:
    #   path='dir1/dir2/file.ext'
    #   parse_path; printf "${path_name} + ${path_ext}\n"
    local _path="$path"; [[ -n $1 ]] && _path="$1"
    path_basename="$_path" path_dir= path_ext=
    [[ ${path_basename: -1} == / ]] && path_basename="${path_basename:0:-1}"
    if [[ $path_basename =~ / ]]; then
        path_dir="${path_basename%/*}/" path_basename="${path_basename##*/}"
        [[ ${path_dir:0:2} == ./ ]] && path_dir="${path_dir:2}"
    fi; path_name="$path_basename"
    if [[ $path_basename =~ ^(.+)(\..*) ]]; then
        path_ext="${BASH_REMATCH[2]}" path_name="${BASH_REMATCH[1]}"
    fi
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
    #   printf "value: $yaml_value\n"
    # TODO: multi-level yaml, quoted strings, more documentation
    # TODO: while read loop
    local _a=0 _arr=() _key= _line=
    mapfile -t _arr <<<"$yaml"; _line="${_arr[0]}"
    while [[ -n $_line || $_a -lt ${#_arr[@]} ]]; do
        if [[ $_line =~ ^([A-Za-z][A-Za-z0-9_]*):\ *(.*) ]]; then
            _key="yaml_${BASH_REMATCH[1]}"; declare -ga "$_key"='()'
            if [[ -n ${BASH_REMATCH[2]} ]]; then
                _line="- ${BASH_REMATCH[2]}"; continue
            fi
        elif [[ $_line =~ ^-\ +(.*) && -n $_key ]]; then
            declare -ga "$_key"+='("${BASH_REMATCH[1]}")'
        elif [[ ! $_line =~ ^\ *(#|$) ]]; then
            msg_error "yaml error: $_line"; return 3
        fi; _line="${_arr[((++_a))]}"
    done
}

print_vars() {
    # Print variable values (arrays in parentheses, unset values <null>).
    # Input:
    #   $@ -- list of variable names
    #   vars -- array of variable names (used if $@ is empty)
    # Usage:
    #   print_vars xval yval
    local _txt= _val= _var= _vars=("${vars[@]}")
    [[ -n $1 ]] && _vars=("$@")
    for _var in "${_vars[@]}"; do
        printf "   $bold$blue$_var$white:$off "
        declare -n "_val=$_var"
        _txt="${!_var}"
        if [[ $(declare -p "$_var" 2>/dev/null) =~ ^declare\ -a ]]; then
            _txt=' '; ((${#_val[@]})) && _txt="$(bin_printf ' %q' "${_val[@]}")"
            _txt="(${_txt:1})"
        elif [[ -z ${_val+x} ]]; then
            _txt="$grey<null>$off"
        fi
        printf "$_txt\n"
    done
}

sub_text() {
    # Format text containing %char sequences, return 3 if error.
    # Input:
    #   $1 -- format string
    #   text -- format string (used if $1 is empty)
    #   subs -- array of char:replacement pairs
    # Output:
    #   text_subbed -- formatted text
    # Usage:
    #   subs=(n:name v:value) text='%n : %v'
    #   sub_text || exit
    #   printf "$text_subbed\n"
    # TODO: printf style padding options?
    local _found=0 _i=0 _repl= _sub= _text="$text"
    [[ -n $1 ]] && _text="$1"
    text_subbed=
    for _sub in "${subs[@]}"; do
        [[ ${_sub:1:1} == : ]] || { msg_error "invalid sub: $_sub"; return 3 ;}
    done
    while [[ $_i -lt ${#text} ]]; do
        _repl="${text:_i:1}"
        if [[ ${text:_i:1} == % ]]; then
            ((_i++))
            if [[ ${text:_i:1} == % ]]; then
                _repl='%'
            else
                _found=0; for _sub in "${subs[@]}"; do
                    if [[ ${text:_i:1} == ${_sub:0:1} ]]; then
                        _repl="${_sub:2}"; ((_found++))
                fi; done
                if ! ((_found)); then
                    msg_error "invalid format character: ${text:_i:1}"
                    return 3
                fi
                ((_found)) || { msg_error "invalid format: ${text:_i:1}"; return 3 ;}
        fi; fi
        text_subbed+="$_repl"; ((_i++))
    done
}

# error, exit, trap:
error() { msg_error "$*"; exit 3 ;}
trap_exit() { ((debug)) && msg_warn '[exit]' ;}
trap_int() { printf '\n'; ((debug)) && msg_warn '[sigint]'; exit 99 ;}

## main ::
trap trap_int INT
trap trap_exit EXIT

# set from env:
[[ -n $DEBUG ]] && debug=1
[[ -n $NO_COLOR || ! -t 1 || ! -t 2 ]] && clear_colors
[[ -n $QUIET ]] && quiet=1 verbose=0
[[ -n $VERBOSE ]] && quiet=0 verbose=1

# parse args:
parse_args || exit
set -- "${args_options[@]}"
while [[ -n $1 ]]; do case "$1" in
    -l|--list) shift; list+=("$1") ;;
    -o|--option) shift; option="$1" ;;
    -Q|--quiet) quiet=1 verbose=0 ;;
    -V|--verbose) quiet=0 verbose=1 ;;
    -M|--nocolor) clear_colors ;;
    -h|-H|--help) print_help ;;
esac; shift; done
((debug)) && print_vars list option quiet

# check for errors:
check_deps || exit

# example: check var:
[[ $(declare -p option 2>/dev/null) =~ ^declare\ -a ]] && msg "option is an array"
[[ -n $option ]] && msg "option is not empty"
[[ -n ${option+x} && -z $option ]] && msg "option is set and empty"
[[ -z ${option+x} ]] && msg "option is not set"

# example: prompt for user input:
#if [[ -z ${option+x} ]]; then
    #read -erp "$green$bold> $off${white}option: $off" option
#fi

# vim:ft=bash
