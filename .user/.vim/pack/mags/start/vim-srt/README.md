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

`:SRTClean`
: Strip trailing whitespaces, remove leading and trailing blank lines, merge
repeated blank lines, fix timecode syntax, add missing spaces after leading
dashes, combine musical notes and pound symbols and add missing spaces around
them, remove blank subtitles, renumber all subtitles. Optionally convert file
to unix, change encoding to utf-8, replace tabs with spaces, and remove various
formatting tags.

`:SRTNumber`
: Renumber subtiles.

`:SRTShift <ms>`
: Shift all subtitle timescodes (positive or negative milliseconds).

`:SRTSkew <timecode> <ms> <timecode> <ms>`
: Skew all subtitle timecodes, calculated from two timecodes and offsets.

`:[range]TextToAscii`
: Convert text to ASCII with transliteration.  Requires iconv.

## Mappings

`<localleader>m`
: `:SRTClean`

`<localleader>n`
: `:SRTNumber`

## Customization

`g:srt_create_maps`
: Create default mappings. (default: true)

### SRTClean

`g:srt_clear_alignment`
: Remove `{\an8}` tags. (default: true)

`g:srt_clear_bold`
: Remove `<b>` tags. (default: true)

`g:srt_clear_font`
: Remove `<font>` tags. (default: true)

`g:srt_clear_italic`
: Remove `<i>` tags. (default: false)

`g:srt_clear_tabs`
: Convert tabs to spaces. (default: true)

`g:srt_to_unix`
: Convert file to unix. (default: true)

`g:srt_to_utf8`
: Set encoding to utf-8. (default: true)

<!--metadata:
author: Chris Magyar <c.magyar.ec@gmail.com>
description: Vim subtitle file plugin.
keywords: vim, vim9script, srt, subtitles
-->
