#!/usr/bin/env python3
## ~/lib/python/cliutils.py ::

"""Command-line interface utilities"""

import argparse
import sys

class HelpFormatter(argparse.HelpFormatter):
    """Subclass of argparse.HelpFormatter with the following changes:
        - command column maximum width increased to 32
        - opt-arg docstring shortened
        - capitalized section headings
        - raw description text formatting
    """

    def __init__(self, prog, max_help=32, **kwargs):
        super().__init__(prog, max_help_position=max_help, **kwargs)

    def add_usage(self, usage, actions, groups, prefix=None):
        if prefix is None:
            prefix = 'Usage: '
        return super().add_usage(usage, actions, groups, prefix.title())

    def start_section(self, heading):
        super().start_section(heading.title())

    def _fill_text(self, text, width, indent):
        return ''.join(indent + line for line in text.splitlines(keepends=True))

    def _format_action_invocation(self, action):
        if not action.option_strings:
            default = self._get_default_metavar_for_positional(action)
            parts = [str(p) for p in self._metavar_formatter(action, default)(1)]
        else:
            parts = [', '.join(action.option_strings)]
            if action.nargs != 0:
                default = self._get_default_metavar_for_optional(action)
                parts += [self._format_args(action, default)]
        return ' '.join(parts)

class ArgumentParser(argparse.ArgumentParser):
    """Subclass of argparse.ArgumentParser."""

    def __init__(self, formatter_class=HelpFormatter, **kwargs):
        super().__init__(formatter_class=HelpFormatter, **kwargs)

    def error(self, message):
        Message().error(message)
        self.exit(2)

class Message:
    """Print messages to stdout and stderr.

    This module provides several basic message printing functions.

    Example:

        > import message
        > msg = message.Message()
        > msg('hello world')
        => hello world

        > msg.error('goodbye pluto')
        E: goodbye pluto
    """

    def __init__(self, nocolor=False) -> None:
        if nocolor or not sys.stdout.isatty() or not sys.stderr.isatty():
            self.nocolor = True
        else:
            self.nocolor = nocolor

    def __call__(self, *args, end='\n') -> None:
        self.msg(' '.join(args), end = end)

    @property
    def nocolor(self) -> bool:
        """ Set/unset colored output. """
        return self._nocolor

    @nocolor.setter
    def nocolor(self, value) -> None:
        self._nocolor = value
        if self._nocolor:
            self.blue, self.green, self.off = '', '', ''
            self.red, self.white, self.yellow = '', '', ''
        else:
            self.blue = '\033[1;38;5;12m'
            self.green = '\033[1;38;5;10m'
            self.off = '\033[0m'
            self.red = '\033[1;38;5;9m'
            self.white = '\033[0;38;5;15m'
            self.yellow = '\033[1;38;5;11m'

    @nocolor.deleter
    def nocolor(self) -> None:
        self.nocolor = False

    def msg(self, *args, end='\n') -> None:
        """ Print info message. """
        print(f'{self.blue}=> {self.white}{" ".join(args)}{self.off}',
              end = end, flush = True)

    def msg2(self, *args, end='\n') -> None:
        """ Print info sub-message. """
        print(f'{self.blue} > {self.white}{" ".join(args)}{self.off}',
              end = end, flush = True)

    def error(self, *args, end='\n') -> None:
        """ Print error message. """
        print(f'{self.red}E: {self.white}{" ".join(args)}{self.off}',
              end = end, flush = True, file = sys.stderr)

    def good(self, *args, end='\n') -> None:
        """ Print status good message. """
        print(f'{self.green}=> {self.white}{" ".join(args)}{self.off}',
              end = end, flush = True)

    def plain(self, *args, end='\n') -> None:
        """ Print plain message. """
        print(f'{self.white}   {" ".join(args)}{self.off}',
              end = end, flush = True)

    def warn(self, *args, end='\n') -> None:
        """ Print warning  message. """
        print(f'{self.yellow}W: {self.white}{" ".join(args)}{self.off}',
              end = end, flush = True, file = sys.stderr)
