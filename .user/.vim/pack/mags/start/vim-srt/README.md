# vim-srt

This is a vim9script filetype plugin for working with subtitle (*.srt*) files.
It adds commands for cleaning, renumbering, and adjusting subtitle timecodes.

## Installation
Install using a plugin manager, or use vim's builtin package support:

    $ mkdir -p ~/.vim/pack/bundle/start
    $ cd ~/.vim/pack/bundle/start
    $ git clone https://github.com/arcmags/vim-srt.git
    $ vim --clean -c 'helptags vim-srt/doc' -c quit

## Usage

Strip all trailing whitespaces, remove leading and trailing blank lines, merge
repeated blank lines, fix syntax errors, and renumber all subtitles.
Optionally convert file to unix, change encoding to utf-8, and replace tabs
with spaces:

    :SRTClean

Renumber subtiles:

    :SRTNumber

Shift all subtitle timescodes by NUMBER milliseconds (positive or negative):

    :SRTShift <NUMBER>

Convert text to ASCII with transliteration (requires `iconv`):

    :[RANGE]SRTTOAscii

## Mappings

`<localleader>m` - `:SRTClean`

`<localleader>n` - `:SRTNumber`

## Customization

`g:srt_maps` -  Create default mappings. default: true

`g:srt_tabs` - Keep tabs with `:SRTClean`. default: false

`g:srt_unix` - Convert file to unix with `:SRTClean`. default: true

`g:srt_utf8` - Set encoding to utf-8 with `:SRTClean`. default: true

<!--metadata:
author: Chris Magyar
description: Vim9script subtitle file plugin.
keywords: vim, vim9script, plugin, subtitle, srt
-->
