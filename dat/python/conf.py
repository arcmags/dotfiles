#!/usr/bin/env python3

"""NAME
    conf.py - covert between json, toml, and yaml

USAGE
    conf.py <FILE>

DESCRIPTION
    conf.py prints input FILE as json, toml, and yaml to stdout.
"""

import sys
import os
import yaml
import json
import toml

has_strictyaml = True
try:
    import strictyaml
except:
    has_strictyaml = False

def msg(msg='') -> None:
    print('\033[1;38;5;12m=> \033[0;38;5;15m' + msg + '\033[0m')

def msg_error(msg='') -> None:
    print('\033[1;38;5;9mE: \033[0;38;5;15m' + msg + '\033[0m', file=sys.stderr)

def msg_warn(msg='') -> None:
    print('\033[1;38;5;11mW: \033[0;38;5;15m' + msg + '\033[0m', file=sys.stderr)

def main() -> int:
    if len(sys.argv) == 1:
        print('usage: conf.py <file>')
        return 5
    file = str(sys.argv[1])

    # read text from file:
    try:
        with open(file, 'r') as f:
            text = f.read()
    except:
        msg_error(f'file error: {file}')
        return 4
    file_base, file_ext = os.path.splitext(file)
    file_ext = file_ext.lower()

    # parse json/toml/yaml, catch errors, save in dict:
    if file_ext == '.json':
        try:
            data = json.loads(text)
        except:
            msg_error(f'json error: {file}')
            return 3
    elif file_ext == '.toml':
        try:
            data = toml.loads(text)
        except:
            msg_error(f'toml error: {file}')
            return 3
    elif file_ext == '.yml' and has_strictyaml:
        try:
            data = strictyaml.load(text).data
        except:
            msg_error(f'strictyaml error: {file}')
            return 3
    elif file_ext in ['.yml', '.yaml']:
        try:
            data = yaml.safe_load(text)
        except:
            msg_error(f'yaml error: {file}')
            return 3
    else:
        msg_error(f'unknown format: {file}')
        return 3

    # dump json/toml/yaml:
    print('## JSON ::')
    print(json.dumps(data, indent=2).rstrip())
    print('\n## TOML ::')
    print(toml.dumps(data).rstrip())
    print('\n## YAML ::')
    print(yaml.dump(data).rstrip())
    return 0

if __name__ == "__main__":
    sys.exit(main())
