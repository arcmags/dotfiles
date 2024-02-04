#!/usr/bin/env python3

"""NAME
    ncoins.py - classic n-coins problem change calculator

SYNOPSIS
    ncoins.py [OPTIONS] <INTEGER...>

DESCRIPTION
    ncoins.py calculates and prints the smallest number of coins required to
    make the desired change.

OPTIONS
    -c, --coins <COIN LIST>
        Comma separated integer list used to make change. (default: 1,5,10,25)

    -H, --help
        Print help.
"""

import re
import sys

__all__ = ["NCoins"]

class NCoins:
    """Classic n-coins problem optimal change calculator.

    This module defines a class that holds a list of coins and calculates the
    smallest set of coins required to make a given amount of change.

    Default coin list = [1, 5, 10, 25].

    Usage example:

        > from ncoins import NCoins

        > coins = NCoins()
        > coins.get_change(66)
        [1, 5, 10, 25, 25]

        > coins.set_coins([1, 5, 10, 25, 50])
        > coins.get_change(66)
        [1, 5, 10, 50]
    """

    def __init__(self, coins: list[int] = None) -> None:
        self.set_coins(coins)

    def get_change(self, change: int) -> list[int]:
        if len(self.change_sets) <= change:
            for ch in range(len(self.change_sets), change + 1):
                ch_set = []
                for c in self.coins:
                    if ch == c:
                        ch_set = [c]
                    elif (ch > c and len(self.change_sets[ch - c]) > 0 and
                            (len(ch_set) == 0 or
                            len(self.change_sets[ch - c]) + 1 < len(ch_set))):
                        ch_set = self.change_sets[ch - c] + [c]
                self.change_sets.append(ch_set)
        return self.change_sets[change]

    def set_coins(self, coins: list[int]) -> None:
        if coins is None:
            self.coins = [1, 5, 10, 25]
        else:
            self.coins = sorted(list(set(coins)))
        self.change_sets = [[]]

    def get_coins(self) -> list[int]:
        return self.coins

def error(msg: str = "") -> None:
    print("E: " + msg, file = sys.stderr)

def main() -> int:
    coins = NCoins()
    change = []
    a = 1
    while a < len(sys.argv):
        a, arg = a + 1, sys.argv[a]
        if arg in ["-h", "-H", "--help"]:
            print(__doc__, end="")
            return 0
        if arg in ["-c", "--coins"]:
            if a < len(sys.argv):
                a, arg = a + 1, sys.argv[a]
                if re.match(r"^\d+(,\d+)*$", arg) is None:
                    error("invalid integer list: " + arg)
                    return 1
            else:
                error("no integer list given")
                return 1
            coins.set_coins([int(i) for i in arg.split(",")])
        else:
            if re.match(r"^\d+$", arg) is None:
                error("invalid integer: " + arg)
                return 1
            change = coins.get_change(int(arg))
    if len(change) == 0:
        return 2
    print("\n".join([str(s) for s in change]))
    return 0

if __name__ == "__main__":
    sys.exit(main())
