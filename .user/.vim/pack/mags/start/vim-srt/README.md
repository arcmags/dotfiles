# vim-srt

This is a vim9script filetype plugin for working with subtitle (*.srt*) files.
It adds various commands for tidying subtitles, renumbering them, modifying
their contents, and adjusting their timecodes.

## Installation
Install using a plugin manager, or use vim's builtin package support:

    $ mkdir -p ~/.vim/pack/bundle/start
    $ cd ~/.vim/pack/bundle/start
    $ git clone https://github.com/arcmags/vim-srt.git
    $ vim --clean -c 'helptags vim-srt/doc' -c quit

## Usage

Strip trailing whitespaces, remove leading and trailing blank lines, merge
repeated blank lines, fix timecode syntax errors, add missing spaces after
leading dashes, combine musical notes and pound symbols and add missing spaces
around them, remove blank subtitles, renumber all subtitles. Optionally convert
file to unix, change encoding to utf-8, replace tabs with spaces, and remove
font colors:

    :SRTClean

Renumber subtiles:

    :SRTNumber

Skew all subtitle timecodes, calculated from two timecodes and offsets:

    :SRTSkew <timecode> <ms> <timecode> <ms>

Shift all subtitle timescodes (positive or negative milliseconds):

    :SRTShift <ms>

Convert text to ASCII with transliteration (requires `iconv`):

    :[RANGE]SRTTOAscii

## Mappings

`<localleader>m` - `:SRTClean`

`<localleader>n` - `:SRTNumber`

## Customization

`g:srt_colors` - Remove font colors with `:SRTClean`. (default: true)

`g:srt_maps` - Create default mappings. (default: true)

`g:srt_tabs` - Keep tabs with `:SRTClean`. (default: false)

`g:srt_unix` - Convert file to unix with `:SRTClean`. (default: true)

`g:srt_utf8` - Set encoding to utf-8 with `:SRTClean`. (default: true)

<!--metadata:
author: Chris Magyar <c.magyar.ec@gmail.com>
description: Vim subtitle file plugin.
keywords: vim, vim9script, srt, subtitles
-->
