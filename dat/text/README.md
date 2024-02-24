# usync

This is a basic rsync wrapper I wrote to be easily configured via text file.
It works well for syncing various machines up with my central storage server.

It's got colored output and its commands are kinda like git. I can just type
`usync push` to sync up with my rpi on the fly. What more could you want?

## Usage

    usync <COMMAND> [OPTIONS]

### Commands

`init` - Create a new usync repo in current directory.

`push` - Push changes to remote source.

`pull` - Pull changes from remote source.

### Options

`-c, --config <FILE>` - Read config from FILE instead of *.usync*.

`-D, --dry-run` - Perform trial run making no changes.

`-V, --verbose`
: Print rsync command.

`-H, --help`
: Display help and exit.

### Config

The `init` command creates a file *.usync* in the current directory.

Character classes may also me used in patterns. See the INCLUDE/EXCLUDE PATTERN
RULES section of the rsync manual for the complete documentation.

----

Author: Chris Magyar
License:
    GPL 3.0

<!--metadata:
author: Chris Magyar <c.magyar.ec@gmail.com>
keywords: usync, rsync, bash
css: ../css/main.css
-->
