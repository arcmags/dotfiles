# pacman Quick Reference

Update system:

    # pacman -Syu

## Install

package:

    # pacman -S <package...>

from specific repo:

    # pacman -S <repo>/<package>

from package file:

    # pacman -U <file...>

## Remove

packages and dependencies:

    # pacman -Rns <package...>

package cache:

    # pacman -Scc

## Query

installed packages:

    $ pacman -Q [package...]

installed package information:

    $ pacman -Qi [package...]

installed pacakge file:

    $ pacman -Ql [package...]

package file:

    $ pacman -Qp [-i|-l] <file...>

packages and descriptions in all repos:

    $ pacman -Ss

all packages in all repos:

    $ pacman -Ssq

packages in group:

    $ pacman -Sgq [group...]

packages in repo:

    $ pacman -Sl [repo...]

orphans:

    $ pacman -Qdtq

package that owns file:

    $ pacman -Qo <file...>

## Files

show package that owns file:

    $ pacman -F <file...>

show all files with name:

    $ pacman -F <name...>
