#!/usr/bin/env python3

"""NAME
    phrase.py - generate randomized phrase

USAGE
    phrase.py [OPTION...] [PHRASE...]

DESCRIPTION
    phrase.py generates randomized phrases from PHRASE. phrase.py uses a
    special phrase dictionary that maps tags to phrases.

    The phrase dictionary is a dictionary with strings as keys that map to lists
    of phrases. A list of phrases may include a tuple for weighted random choice.

    PHRASE is a string that may contain tags. Tags are strings enclosed in
    <...>. If a tag has a corresponding key in the phrase dictionary, the tag
    is replaced with a randomly selected phrase from it's list.

    PHRASES may also contain inline phrase lists to randomly select from.

    The special tag <src> is the default phrase used if none is given.

OPTIONS
    -f, --file FILE
        Parse phrase dictionary from json, toml, or yaml FILE.

    -H, --help
        Print help.
"""

import sys
import random

class PhraseDict:
    """Phrase Dictionary used to generate randomized phrases
    """

    def __init__(self, pdict: dict = None) -> None:
        self.pdict = pdict
        if self.pdict is None:
            self.pdict = {
                'src': ['random <phrase> <generator>'],
                'phrase': ['phrase', 'sentence'],
                'generator': [['<builder>', 'generator'], (10, 20)],
                'builder': [['builder', 'maker'], (20, 10)]
            }

    def add_pdict(self, pdict: dict = None) -> None:
        self.pdict.update(pdict)

    def clear_pdict(self) -> None:
        self.pdict = {}

    def get_pdict(self) -> str:
        return str(self.pdict)

    def get_phrase(self, text: str = '<src>') -> str:

        phrase = text
        tag = ''


        return text

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
    opt_files = []
    a = 1
    while a < len(sys.argv):
        arg = sys.argv[a]
        if arg in ['-H', '--help']:
            print(__doc__)
            exit(0)
        elif arg in ['-f', '--file']:
            a += 1
            if a >= len(sys.argv):
                error(f'option requires an argument: {arg}')
            opt_files += [sys.argv[a]]
        elif arg == '--':
            a += 1
            break
        else:
            break
        a += 1
    opt_args = sys.argv[a:]
    str_args = ' '.join(opt_args)

    pdict = PhraseDict()
    print(pdict.get_pdict())

    return 0

if __name__ == '__main__':
    sys.exit(main())
