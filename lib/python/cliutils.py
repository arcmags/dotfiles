#!/usr/bin/env python3
## ~/lib/python/cliutils.py ::

"""Command-line interface utilities

This module is a collection of command-line interface utilites.
"""

__version__ = '1.1'
__all__ = [
    'ArgumentParser',
    'Message',
    'get_env',
    'get_env_bool',
    'is_dir',
    'is_file',
    'is_path',
    'is_readable',
    'is_writable',
    'parse_yaml',
    'read_file',
    'run_cmd',
    'to_str',
]


import argparse
import os
import readline # pylint: disable=W0611
import subprocess
import sys
import yaml

def get_env(var: str, alt='') -> str:
    """Returns environment variable."""
    return os.environ.get(var, alt)

def get_env_bool(var: str) -> bool:
    """Returns true if environment variable is not empty."""
    return os.environ.get(var, '') != ''

def set_env(var: str, val: str) -> None:
    """Sets environment variable."""
    os.environ[var] = str(val)

def is_dir(path: str) -> bool:
    """Check if path is a directory."""
    return os.path.exists(path) and not os.path.isfile(path)

def is_file(path: str) -> bool:
    """Check if path is a file."""
    return os.path.isfile(path)

def is_path(path: str) -> bool:
    """Check if path exists."""
    return os.path.exists(path)

def is_readable(path: str) -> bool:
    """Check if path is a readable."""
    return os.access(path, os.R_OK)

def is_writable(path: str) -> bool:
    """Check if path is a writable."""
    return os.access(path, os.W_OK)

def parse_yaml(text: str) -> dict:
    """Parse yaml. Return dictionary."""
    try:
        return yaml.safe_load(text)
    except yaml.parser.ParserError:
        Message().error('yaml parsing error')
    except: # pylint: disable=W0702
        Message().error('yaml error')
    return None

def read_file(file: str, encoding='utf-8') -> str:
    """Read file. Return text if success."""
    try:
        with open(file, 'r', encoding=encoding) as f:
            return f.read().rstrip()
    except FileNotFoundError:
        Message().error(f'file not found: {file}')
    except IsADirectoryError:
        Message().error(f'file is a dir: {file}')
    except PermissionError:
        Message().error(f'permission denied: {file}')
    except: # pylint: disable=W0702
        Message().error('read error: {file}')
    return None

def write_file(file: str, text: str, encoding='utf-8') -> bool:
    """Write file. Return True if success."""
    try:
        with open(file, 'w', encoding=encoding) as f:
            f.write(text)
            return True
    except FileNotFoundError:
        Message().error(f'path not found: {file}')
    except IsADirectoryError:
        Message().error(f'file is a dir: {file}')
    except PermissionError:
        Message().error(f'permission denied: {file}')
    except: # pylint: disable=W0702
        Message().error(f'write error: {file}')
    return False

def run_cmd(cmd: list) -> str:
    """Execute external command. Return stdout if success."""
    try:
        proc = subprocess.run(cmd, stdout=subprocess.PIPE, check=False,
                              stderr=subprocess.PIPE, text=True)
        if proc.returncode == 0:
            return proc.stdout.rstrip()
        Message().error(f'command failed: {cmd}')
    except FileNotFoundError:
        Message().error(f'command not found: {cmd[0]}')
    except:  # pylint: disable=W0702
        Message().error(f'command error: {cmd}')
    return None

def to_str(*args, sep=' ') -> str:
    """Returns all arguments as single string."""
    return sep.join([str(a) for a in args])


class Message:
    """Print messages to stdout and stderr.

    This class provides basic colored message printing functions. Color is
    enabled by default when stdout and stderr are connected to a terminal.

    Keyword Arguments:
        - nocolor -- disable colored output (default: False)
    """

    def __init__(self, nocolor=False) -> None:
        if not sys.stdout.isatty() or not sys.stderr.isatty() or get_env_bool('NO_COLOR'):
            self.nocolor = True
        else:
            self.nocolor = nocolor

    def __call__(self, *args, end='\n') -> None:
        self.msg(*args, end=end)

    @property
    def nocolor(self) -> bool:
        """Set/unset color attributes."""
        return self._nocolor

    @nocolor.setter
    def nocolor(self, value) -> None:
        if value:
            self._nocolor = True
            self.black, self.blue, self.cyan, self.green = '', '', '', ''
            self.grey, self.magenta, self.orange, self.red = '', '', '', ''
            self.yellow, self.white, self.bold, self.off = '', '', '', ''
        else:
            self._nocolor = False
            self.black, self.blue, = '\033[38;5;0m', '\033[38;5;12m'
            self.cyan, self.green = '\033[38;5;14m', '\033[38;5;10m'
            self.grey, self.magenta = '\033[38;5;8m', '\033[38;5;13m'
            self.orange, self.red = '\033[38;5;3m', '\033[38;5;9m'
            self.white, self.yellow = '\033[38;5;15m', '\033[38;5;11m'
            self.bold, self.off = '\033[1m', '\033[0m'

    @nocolor.deleter
    def nocolor(self) -> None:
        self.nocolor = False

    def msg(self, *args, end='\n') -> None:
        """Print info message."""
        print(f'{self.bold}{self.blue}=> {self.off}{self.white}{to_str(
              *args)}{self.off}', end=end, flush=True)

    def msg2(self, *args, end='\n') -> None:
        """Print info message."""
        print(f'{self.bold}{self.blue} > {self.off}{self.white}{to_str(
              *args)}{self.off}', end=end, flush=True)

    def cmd(self, *args, end='\n') -> None:
        """Print command message."""
        prompt = f'{self.green}-$ ' if os.getuid() != 0 else f'{self.red}:# '
        print(f'{self.bold}{prompt}{self.off}{self.white}{to_str(
              *args)}{self.off}', end=end, flush=True, file=sys.stderr)

    def error(self, *args, end='\n') -> None:
        """Print error message."""
        print(f'{self.bold}{self.red}E: {self.off}{self.white}{to_str(
              *args)}{self.off}', end=end, flush=True, file=sys.stderr)

    def good(self, *args, end='\n') -> None:
        """Print good info/status message."""
        print(f'{self.bold}{self.green}=> {self.off}{self.white}{to_str(
              *args)}{self.off}', end=end, flush=True)

    def plain(self, *args, end='\n') -> None:
        """Print plain message."""
        print(f'{self.off}   {self.white}{to_str( *args)}{self.off}',
              end=end, flush=True)

    def warn(self, *args, end='\n') -> None:
        """Print warning  message."""
        print(f'{self.bold}{self.yellow}W: {self.off}{self.white}{to_str(
              *args)}{self.off}', end=end, flush=True, file=sys.stderr)


class HelpFormatter(argparse.RawDescriptionHelpFormatter):
    """Subclass of argparse.RawDescriptionHelpFormatter with various changes.

    Changes applied to argparse.RawDescriptionHelpFormatter:
        - command column maximum width increased to 32
        - opt-arg docstring shortened
        - capitalized section headings
        - added line break after Usage heading
        - removed positional arguments section
        - help always printed last in usage string and option list
    """

    def __init__(self, prog, max_help=32, **kwargs):
        super().__init__(prog, max_help_position=max_help, **kwargs)

    def add_arguments(self, actions):
        help_action = None
        for action in actions:
            if isinstance(action, argparse._HelpAction): # pylint: disable=W0212
                help_action = action
            else:
                self.add_argument(action)
        if help_action is not None:
            self.add_argument(help_action)

    def add_usage(self, usage, actions, groups, prefix=None):
        actions_new = []
        action_help = None
        for action in actions:
            if isinstance(action, argparse._HelpAction): # pylint: disable=W0212
                action_help = action
            else:
                actions_new += [action]
        if action_help is not None:
            actions_new += [action_help]
        actions = actions_new
        if prefix is None:
            prefix = 'Usage:\n  '
        return super().add_usage(usage, actions, groups, prefix.title())

    def start_section(self, heading):
        super().start_section(heading.title())

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

    class _Section(argparse.HelpFormatter._Section): # pylint: disable=W0212,R0903

        def format_help(self):
            if (self.heading is not None
                and self.heading.lower() == 'positional arguments'):
                return ''
            return super().format_help()


class ArgumentParser(argparse.ArgumentParser):
    """Subclass of argparse.ArgumentParser with various changes.

    Changes applied to argparse.ArgumentParser:
        - allow_abbrev is False by default
        - formatter_class is cliutils.HelpFormatter by default
        - set epilog to any text in __doc__ after first ---- line
        - shortened error message
        - print help with -H or --help

    Added methods:
        - add_arg_append -- add arg that appends option value to list
        - add_arg_positionals -- add positional args, capture all
        - add_arg_set -- add arg that sets option value
        - add_arg_true -- add basic flag arg
    """

    def __init__(self, formatter_class=HelpFormatter, allow_abbrev=False,
                 add_help=True, description=None, epilog=None, **kwargs):
        if description is not None and epilog is None:
            description_parts = description.split('\n----\n', 1)
            if len(description_parts) > 1:
                description = description_parts[0]
                epilog = description_parts[1]
        super().__init__(formatter_class=formatter_class, add_help=False,
                         allow_abbrev=allow_abbrev, description=description,
                         epilog=epilog, **kwargs)
        if add_help:
            self.add_help = True
            self.add_argument('-H', '--help', default=argparse.SUPPRESS,
                              action='help', help='print help and exit')

    def add_arg_append(self, *args, metavar='<arg>', **kwargs) -> None:
        """Add argument that appends option value to list."""
        self.add_argument(*args, action='append', default=[], metavar=metavar,
                          **kwargs)

    def add_arg_positionals(self, name, metavar='<parg>', **kwargs) -> None:
        """Add positional arguments, capture rest of args, suppress help."""
        self.add_argument(name, metavar=metavar, nargs=argparse.REMAINDER, **kwargs)

    def add_arg_set(self, *args, metavar='<arg>', **kwargs) -> None:
        """Add argument that sets single option value."""
        self.add_argument(*args, metavar=metavar, **kwargs)

    def add_arg_true(self, *args, **kwargs) -> None:
        """Add basic flag argument."""
        self.add_argument(*args, action='store_true', **kwargs)

    def error(self, message) -> None:
        Message().error(message)
        self.exit(2)
