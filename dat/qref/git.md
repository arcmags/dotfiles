# Git Quick Reference

## Create

Create git repository in current directory:

    $ git init [-b <branch>]

Add a remote (useful for things like github):

    $ git remote add <remote> <url>

Push or pull from remote for first time:

    $ git {push|pull} <remote> <branch>

## Clone

Clone remote git repository:

    $ git clone [--recurse-submodules] <url> [<dir>]

Shallow clone remote git repository:

    $ git clone --depth 1 <url> [<dir>]

## Add, Commit, Push

Add files, commit, and push changes:

    $ git add [--all] [files...]
    $ git commit [-S] [-m <message>]
    $ git push [remote] [branch]

## Branch

List branches:

    $ git branch [-v]

Create branch:

    $ git checkout -b <branch>

Checkout (switch to) branch:

    $ git checkout <branch>

Push new local branch to remote:

    $ git push -u origin <branch>

List remote branches:

    $ git branch -r [-v]

Checkout (download and switch to) remote branch:

    $ git checkout -b <branch> <remote>/<branch>

## Stash

Use stash to save the current uncommitted changes and revert files back to the
last commit. Useful if working on something and not ready to commit yet.

Stash current uncommitted changes:

    $ git stash

Restore stashed changes:

    $ git stash apply

## Fetch, Merge

Add another remote:

    $ git remote add <remote2> <url>

Fetch from new remote:

    $ git fetch <remote2>

Merge changes from new remote:

    $ git checkout <branch>
    $ git merge <remote2>/<branch>

Push to original remote:

    $ git push

## Rebase

Rebase branch to main/master:

    $ git checkout <branch>
    $ git rebase {main|master}

Push to remote:

    $ git push --force

## Submodules

Add submodule:

    $ git submodule add <url>
    $ git push

Init and pull submodules:

    $ git submodule init
    $ git submodule update

### note

If any submodules fail to update, they all fail to checkout. You need to
individually update each submodule then:

    $ git submodule init
    $ for m in $(git submodule status | cut -f2 -d' '); do git submodule update "$m"; done

## Various

Use `-C <path>` to run git as if in *path* instead of current directory:

    $ git -C <path> <command>

### checks

Check if *path* is in a git repo:

    $ git -C <path> rev-parse >/dev/null 2>&1 && echo true

Check if *path* is the root of a git repo:

    $ [ "$(git -C <path> rev-parse --git-dir)" = '.git' ] && echo true
