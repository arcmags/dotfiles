#!/usr/bin/env python3

## tabs2spaces.py ::
# Convert tabs to spaces. I wrote this before I discovered `expand` in GNU
# coreutils which does the exact same thing.

"""NAME
    tabs2spaces.py

DESCRIPTION
    Convert tabs to spaces in a way that makes sense. Each tab is replaced by
    the required number of spaces to get to the next tabstop.

USAGE
    tabs2spaces.py [OPTIONS] <FILES...>

OPTIONS
    -H, --help
        Print help.

    -O, --overwrite
        Overwrite input files in place.

    -Q, --quiet
        Do not print any output.

    -t, --tabstop <number>
        Use <number> as tabstop value. (default = 8)
"""

import sys
import shutil
from pathlib import Path

## config ::
tabstop = 8

# internal ::
files = []

# args:
arg_quiet = False
arg_output = ""
arg_overwrite = False

def msg(msg=""):
    if not arg_quiet:
        print("\033[1;38;5;12m==> \033[0m" + msg)

def msg_error(msg=""):
    if not arg_quiet:
        print("\033[1;38;5;9m==> \033[0m" + msg, file=sys.stderr)

## main ::
a = 1
while a < len(sys.argv):
    arg = sys.argv[a]
    a += 1
    if arg in ["-h", "-H", "--help"]:
        print(__doc__)
        exit(0)
    elif arg in ["-O", "--overwrite"]:
        arg_overwrite = True
    elif arg in ["-Q", "--quiet"]:
        arg_quiet = True
    elif arg in ["-t", "--tabstop"]:
        try:
            tabstop = int(sys.argv[a])
        except IndexError:
            msg_error("required arg: " + arg + " <number>")
            exit(1)
        except ValueError:
            msg_error("invalid number: " + arg)
            exit(1)
        a += 1
    elif arg[0:2] == "-t":
        try:
            tabstop = int(arg[2:])
        except ValueError:
            msg_error("invalid number: " + arg[2:])
            exit(1)
    elif not Path(arg).is_file():
        msg_error("invalid file: " + arg)
        exit(1)
    else:
        files += [arg]

for file in files:
    lines = []
    lines_out = []
    with open(file, "r") as f:
        lines = f.readlines()
    for line in lines:
        line_out = ""
        c = 0
        for char in line:
            if char != "\t":
                line_out += char
                c += 1
            elif c % tabstop == 0:
                line_out += " " * tabstop
                c += tabstop
            else:
                line_out += " " * (tabstop - c % tabstop)
                c += tabstop - c % tabstop
        lines_out += [line_out]
    if lines_out != lines:
        if not arg_overwrite:
            shutil.copy(arg, arg + "_original")
        with open(file, "w") as f:
            f.writelines(lines_out)
        msg("file modified: " + file)
