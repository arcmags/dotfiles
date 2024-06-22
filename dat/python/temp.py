#!/usr/bin/env python3

"""NAME
    temp.py - template python script

USAGE
    temp.py [OPTION...] [ARG...]

DESCRIPTION
    Python example/template script.

OPTIONS
    -i, --input INPUT
        Add to input argument list.

    -P, --print
        Print command line arguments.

    -H, --help
        Print help.
"""

import sys

def error(msg='') -> None:
    msg_error(msg)
    exit(1)

def msg(msg='') -> None:
    print(f'\033[1;38;5;12m=> \033[0;38;5;15m{msg}\033[0m')

def msg_error(msg='') -> None:
    print(f'\033[1;38;5;9mE: \033[0;38;5;15m{msg}\033[0m', file=sys.stderr)

def msg_warn(msg='') -> None:
    print(f'\033[1;38;5;11mW: \033[0;38;5;15m{msg}\033[0m', file=sys.stderr)

def main() -> int:
    flg_print = False
    opt_args = []
    opt_inputs = []
    a = 1
    while a < len(sys.argv):
        arg = sys.argv[a]
        if arg in ['-H', '--help']:
            print(__doc__)
            exit(0)
        elif arg in ['-P', '--print']:
            flg_print = True
        elif arg in ['-i', '--input']:
            a += 1
            if a >= len(sys.argv):
                error(f'option requires an argument: {arg}')
            opt_inputs += [sys.argv[a]]
        elif arg == '--':
            a += 1
            break
        else:
            break
        a += 1
    opt_args = sys.argv[a:]

    if flg_print:
        msg(f'opt_inputs = [{', '.join(opt_inputs)}]')
        msg(f'opt_args = [{', '.join(opt_args)}]')

    return 0

if __name__ == '__main__':
    sys.exit(main())
