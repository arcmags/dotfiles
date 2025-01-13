#!/usr/bin/env python3
## snippets.py ::

"""Various python functions and snippets."""


import os
import sys


def number_to_base(n: int, b: int) -> list[str]:
    """Convert positive number to any base. Returns list of strings."""
    if type(n) is not int or n < 0:
        return ['0']
    if n == 0:
        return ['0']
    if type(b) is not int or b < 2:
        return ['0']
    digits = []
    while n:
        n, r = divmod(n, b)
        digits += [str(r)]
    return digits
