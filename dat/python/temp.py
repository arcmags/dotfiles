#!/usr/bin/env python3
## temp.py ::

"""Python example/template script."""

import os
import sys
import argparse
#import yaml
import cliutils

def main() -> int:
    p = cliutils.ArgumentParser(description=__doc__)
    p.add_argument('-a', '--arg', dest='args', action='append', metavar='<arg>',
                   default=[], help='append to args')
    p.add_argument('-M', '--nocolor', action='store_true', help='disable colored output')
    p.add_argument('-Q', '--quiet', action='store_true', help='output nothing to stdout')
    p.add_argument('pargs', metavar='<arg>', nargs=argparse.REMAINDER, help='positional arguments')
    args = p.parse_args()

    # set envronment:
    debug = os.environ.get('DEBUG', '0').lower() in ['1', 'true', 'yes']
    nocolor = os.environ.get('NOCOLOR', '0').lower() in ['1', 'true', 'yes']
    quiet = os.environ.get('QUIET', '0').lower() in ['1', 'true', 'yes']
    verbose = os.environ.get('VERBOSE', '0').lower() in ['1', 'true', 'yes']
    if args.nocolor:
        nocolor = True
    if args.quiet:
        quiet = True

    # initialize messages:
    msg = cliutils.Message(nocolor=nocolor)

    ## main ::
    if len(args.args) > 0:
        msg('args:')
        for arg in args.args:
            msg.msg2(arg)
    if len(args.pargs) > 0:
        msg('pargs:')
        for arg in args.pargs:
            msg.msg2(arg)

    if debug:
        msg.warn('DEBUG MODE')

    return 0

if __name__ == '__main__':
    sys.exit(main())
