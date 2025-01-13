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

    # run external command:
    cmd = ['date', '-I']
    if (stdout := cliutils.run_cmd(cmd)) is None:
        msg.warn('command error caught')

    # check file:
    file, stat = '/etc/fstab', []
    if cliutils.is_file(file):
        stat += ['file']
    if cliutils.is_dir(file):
        stat += ['directory']
    if cliutils.is_path(file):
        stat += ['exists']
    if cliutils.is_readable(file):
        stat += ['readable']
    if cliutils.is_writable(file):
        stat += ['writable']
    msg(f'{file}: {', '.join(stat)}')

    # read file:
    file = '/etc/fstab'
    if (text := cliutils.read_file(file)) is None:
        msg.warn('read error caught')

    # write file:
    file = '/tmp/newfile.txt'
    text = 'Hello World\n'
    if not (success := cliutils.write_file(file, text)):
        msg.warn('write error caught')

    # parse yaml:
    file = '/home/mags/user/dat/python/temp.yaml'
    if (text := cliutils.read_file(file)) is None:
        msg.warn('read error caught')
    elif (data := cliutils.parse_yaml(text)) is None:
        msg.warn('yaml error caught')

    # prompt for user input:
    if args.var is None:
        args.var = input(f'{msg.green}> {msg.white}var: {msg.off}')

    # print args:
    if not quiet:
        msg.msg2(f'list: {cliutils.to_str(args.list)}')
        msg.msg2(f'pargs: {cliutils.to_str(args.pargs)}')
        msg.msg2(f'var: {args.var}')

    return 0

if __name__ == '__main__':
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        print()
        cliutils.Message().error('keyboard interrupt')
        sys.exit(99)
