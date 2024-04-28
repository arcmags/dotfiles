#!/bin/bash
## spoke-calc.bash ::

print_help() {
cat <<'HELPDOC'
NAME
    spoke-calc.bash - calculate spoke length

SYNOPSIS
    spoke-calc.bash

DESCRIPTION
    spoke-calc.bash prompts for valid hub and rim measurements
    and calculates the required spoke length.
HELPDOC
}

## internal control ::
reqs=(bc)
cnt=
crs=
dia=
dia_l=
dia_r=
erd=
hdi=
len=
len_l=
len_r=
off=
off_l=
off_r=
pi=3.141593

## functions ::
msg() { printf "\e[1;38;5;12m=> \e[0;38;5;15m$1\e[0m\n" "${@:2}" ;}
error() { printf "\e[1;38;5;9mE: \e[0;38;5;15m$1\e[0m\n" "${@:2}" >&2; exit 5 ;}
chk_pos_num() { [[ "$1" =~ ^([1-9][0-9]*\.?|0\.0*[1-9]+)[0-9]*$ ]] || error "$1" ;}
chk_pos_int() { [[ "$1" =~ ^[1-9][0-9]*$ ]] || error "$1" ;}

## main() ::
for arg in "$@"; do case "$arg" in
    -H|--help) print_help; exit 0 ;;
    *) error "unknown arg: $arg" ;;
esac; done

for req in "${reqs[@]}"; do if ! command -v "$req" &>/dev/null; then
    error "missing requirement: $req"
fi; done

read -i "$erd" -erp $'\e[1;38;5;10m''> '$'\e[0;38;5;15m''ERD: '$'\e[0m' erd
chk_pos_num "$erd"

read -i "$dia_l" -erp $'\e[1;38;5;10m''> '$'\e[0;38;5;15m''flange diameter (left): '$'\e[0m' dia_l
chk_pos_num "$dia_l"
[ "$(bc -l <<<"$dia_l >= $erd")" -eq 1 ] && error "$dia_l >= $erd"

read -i "$off_l" -erp $'\e[1;38;5;10m''> '$'\e[0;38;5;15m''flange offset (left): '$'\e[0m' off_l
chk_pos_num "$off_l"

read -i "$dia_r" -erp $'\e[1;38;5;10m''> '$'\e[0;38;5;15m''flange diameter (right): '$'\e[0m' dia_r
chk_pos_num "$dia_r"
[ "$(bc -l <<<"$dia_r >= $erd")" -eq 1 ] && error "$dia_r >= $erd"

read -i "$off_r" -erp $'\e[1;38;5;10m''> '$'\e[0;38;5;15m''flange offset (right): '$'\e[0m' off_r
chk_pos_num "$off_r"

#read -i "$dia" -erp $'\e[1;38;5;10m''> '$'\e[0;38;5;15m''flange diameter: '$'\e[0m' dia
#chk_pos_num "$dia"
#[ "$(bc -l <<<"$dia >= $erd")" -eq 1 ] && error "$dia >= $erd"

#read -i "$off" -erp $'\e[1;38;5;10m''> '$'\e[0;38;5;15m''flange offset: '$'\e[0m' off
#chk_pos_num "$off"

read -i "$hdi" -erp $'\e[1;38;5;10m''> '$'\e[0;38;5;15m''spoke hole diameter: '$'\e[0m' hdi
chk_pos_num "$hdi"

read -i "$crs" -erp $'\e[1;38;5;10m''> '$'\e[0;38;5;15m''cross pattern: '$'\e[0m' crs
chk_pos_int "$crs"

read -i "$cnt" -erp $'\e[1;38;5;10m''> '$'\e[0;38;5;15m''spoke count: '$'\e[0m' cnt
chk_pos_int "$cnt"

len_l="$(bc -l <<<"l=sqrt(($erd/2)^2+($dia_l/2)^2+$off_l^2-$erd*$dia_l/2*c(4*$pi*$crs/$cnt))-$hdi/2; scale=1;(l+.05)/1")"
len_r="$(bc -l <<<"l=sqrt(($erd/2)^2+($dia_r/2)^2+$off_r^2-$erd*$dia_r/2*c(4*$pi*$crs/$cnt))-$hdi/2; scale=1;(l+.05)/1")"
#len="$(bc -l <<<"l=sqrt(($erd/2)^2+($dia/2)^2+$off^2-$erd*$dia/2*c(4*3.141593*$crs/$cnt))-$hdi/2; #scale=1;(l+.05)/1")"

msg "spoke length (left): $len_l"
msg "spoke length (right): $len_r"

# vim:ft=bash
