#!/usr/bin/env python3
## temp.py ::
# pylint: disable=W0612

"""Python example/template script.
----
Environment:
  NO_COLOR      disable colored output
  QUIET         run silently
  VERBOSE       run verbosely
"""

import sys
import cliutils

import tty
import termios

def get_key() -> str:
    fd = sys.stdin.fileno()
    settings = termios.tcgetattr(fd)
    try:
        tty.setraw(fd)
        key = sys.stdin.read(1)
    except:
        cliutils.Message().error('keypress error')
    termios.tcsetattr(fd, termios.TCSADRAIN, settings)
    return key

def main() -> int:
    # set from env:
    debug = cliutils.get_env_bool('DEBUG')
    nocolor = cliutils.get_env_bool('NO_COLOR')
    quiet = cliutils.get_env_bool('QUIET')
    verbose = cliutils.get_env_bool('VERBOSE')

    # set and parse args:
    parser = cliutils.ArgumentParser(description=__doc__)
    parser.add_arg_append('-l', '--list', help='append to list')
    parser.add_arg_set('-v', '--var', help='set variable')
    parser.add_arg_true('-M', '--nocolor', help='disable colored output')
    parser.add_arg_true('-Q', '--quiet', help='print nothing to stdout')
    parser.add_arg_true('-V', '--verbose', help='print more verbose information')
    parser.add_arg_positionals('pargs')
    args = parser.parse_args()

    # set env from args:
    if args.nocolor:
        cliutils.set_env('NO_COLOR', True)
        nocolor = True
    if args.quiet: quiet, verbose = True, False
    if args.verbose: quiet, verbose = False, True

    # initialize message printer:
    msg = cliutils.Message(nocolor=nocolor)

    key = get_key()

    print(type(key))
    print(key)

    return 0

if __name__ == '__main__':
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        print()
        cliutils.Message().error('keyboard interrupt')
        sys.exit(99)
