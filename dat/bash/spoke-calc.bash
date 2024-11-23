#!/bin/bash
## spoke-calc.bash ::

print_help() {
cat <<'HELPDOC'
NAME
    spoke-calc.bash - calculate spoke length

DESCRIPTION
    spoke-calc.bash prompts for hub and rim measurements
    and calculates the required spoke length.
HELPDOC
}; [ "$0" != "$BASH_SOURCE" ] && { print_help; return 0 ;}

## control ::
deps=(bc)
pi=3.141593

## functions ::
ck_float() { [[ "$1" =~ ^([1-9][0-9]*\.?|0\.0*[1-9]+)[0-9]*$ ]] || error 'invalid number' ;}
ck_int() { [[ "$1" =~ ^[1-9][0-9]*$ ]] || error 'invalid number' ;}
error() { msg_error "$@"; exit 5 ;}
input() { read -erp $'\e[1;38;5;10m: \e[0;38;5;15m'"$1 "$'\e[0m' "$2" ;}
is_cmd() { command -v "$1" &>/dev/null ;}
msg() { printf '\e[1;38;5;12m=> \e[0;38;5;15m%s\e[0m\n' "$*" ;}
msg_error() { printf '\e[1;38;5;9mE: \e[0;38;5;15m%s\e[0m\n' "$*" >&2 ;}

## main() ::
trap exit INT
for arg in "$@"; do case "$arg" in
    -H|--help) print_help; exit 0 ;;
    *) error "unknown arg: $arg" ;;
esac; done

# check dependencies:
for dep in "${deps[@]}"; do is_cmd "$dep" || error "missing dep: $dep"; done

input 'ERD:' erd
ck_float "$erd"

input 'flange diameter (left):' dia_l
ck_float "$dia_l"
[ "$(bc -l <<<"$dia_l >= $erd")" -eq 1 ] && error "$dia_l >= $erd"

input 'flange offset (left):' off_l
ck_float "$off_l"

input 'flange diameter (right): ' dia_r
ck_float "$dia_r"
[ "$(bc -l <<<"$dia_r >= $erd")" -eq 1 ] && error "$dia_r >= $erd"

input 'flange offset (right): ' off_r
ck_float "$off_r"

input 'spoke hole diameter: ' hdi
ck_float "$hdi"

input 'cross pattern: ' crs
ck_int "$crs"

input 'spoke count: ' cnt
ck_int "$cnt"

len_l="$(bc -l <<<"l=sqrt(($erd/2)^2+($dia_l/2)^2+$off_l^2-$erd*$dia_l/2*c(4*$pi*$crs/$cnt))-$hdi/2; scale=1;(l+.05)/1")"
len_r="$(bc -l <<<"l=sqrt(($erd/2)^2+($dia_r/2)^2+$off_r^2-$erd*$dia_r/2*c(4*$pi*$crs/$cnt))-$hdi/2; scale=1;(l+.05)/1")"

msg "spoke length (left): $len_l"
msg "spoke length (right): $len_r"

# vim:ft=bash
