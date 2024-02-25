#!/usr/bin/env python3

"""NAME
    template.py
"""

import sys

def str_ask(msg='', prompt='[y/N]') -> str:
    return '\033[1;38;5;12m:: \033[0;38;5;15m' + msg + '? ' + prompt + '\033[0m '

def msg(msg='') -> None:
    print('\033[1;38;5;12m==> \033[0;38;5;15m' + msg + '\033[0m')

def msg_error(msg='') -> None:
    print('\033[1;38;5;9mE: \033[0;38;5;15m' + msg + '\033[0m', file=sys.stderr)

def msg_warn(msg='') -> None:
    print('\033[1;38;5;11mW: \033[0;38;5;15m' + msg + '\033[0m', file=sys.stderr)

def main() -> int:
    print('template.py')
    return 0

if __name__ == "__main__":
    sys.exit(main())
