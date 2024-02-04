#!/usr/bin/env python3

"""NAME
    message.py

DESCRIPTION
    Print message

USAGE
    message.py [OPTIONS] [--] MESSAGE

OPTIONS
    -H, --help
        Print help.

    -C, --color=always
        Enable color

    -M, --color=never
        Disable color

    -I, --info
        Print info message.

    -S, --subinfo
        Print sub-info message.

    -W, --warn
        Print warning message to stderr.

    -E, --error
        Print error message to stderr.
"""

import sys

class Message:
    """Print messages to stdout and stderr.

    This module provides several basic message printing functions.
    Colors are not used if output is piped or redirected.

    Example:

        > import message
        > msg = message.Message()

        > msg("hello world")
        hello world

        > msg.error("goodbye pluto")
        E: goodbye pluto
    """

    def __init__(self):
        self.color_off()
        if sys.stdout.isatty() and sys.stderr.isatty():
            self.color_on()

    def __call__(self, *args, end = "\n"):
        self.plain(" ".join(args), end = end)

    def color_off(self):
        self.boldblue, self.boldred, self.boldyellow = "", "", ""
        self.white, self.reset = "", ""

    def color_on(self):
        self.boldblue = "\033[1;38;5;12m"
        self.boldred = "\033[1;38;5;9m"
        self.boldyellow = "\033[1;38;5;11m"
        self.white = "\033[0;38;5;15m"
        self.reset = "\033[0m"

    def plain(self, *args, end = "\n"):
        print(self.reset + self.white + " ".join(args) + self.reset,
              end = end, flush = True)

    def info(self, *args, end = "\n"):
        print(self.boldblue + "==> " + self.white + " ".join(args) + self.reset,
              end = end, flush = True)

    def subinfo(self, *args, end = "\n"):
        print(self.boldblue + " -> " + self.white + " ".join(args) + self.reset,
              end = end, flush = True)

    def warn(self, *args , end = "\n"):
        print(self.boldyellow + "W: " + self.white + " ".join(args) + self.reset,
              end = end, flush = True, file = sys.stderr)

    def error(self, *args, end = "\n"):
        print(self.boldred + "E: " + self.white + " ".join(args) + self.reset,
              end = end, flush = True, file = sys.stderr)

## main ::
def main() -> int:
    msg = Message()
    msg_type = "plain"
    a = 1
    while a < len(sys.argv):
        arg = sys.argv[a]
        if arg in ["-H", "--help"]:
            print(__doc__, end="")
            return(0)
        elif arg in ["-M", "--color=never"]:
            msg.color_off()
        elif arg in ["-C", "--color=always"]:
            msg.color_on()
        elif arg in ["-I", "--info"]:
            msg_type = "info"
        elif arg in ["-S", "--subinfo"]:
            msg_type = "subinfo"
        elif arg in ["-W", "--warn"]:
            msg_type = "warn"
        elif arg in ["-E", "--error"]:
            msg_type = "error"
        elif arg == "--":
            a = a + 1
            break
        else:
            break
        a = a + 1
    if a < len(sys.argv):
        text = " ".join([str(s) for s in sys.argv[a: len(sys.argv)]])
        if msg_type == "plain":
            msg(text)
        if msg_type == "info":
            msg.info(text)
        if msg_type == "subinfo":
            msg.subinfo(text)
        if msg_type == "warn":
            msg.warn(text)
        if msg_type == "error":
            msg.error(text)
    return(0)

if __name__ == "__main__":
    sys.exit(main())
