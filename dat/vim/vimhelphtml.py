#!/usr/bin/env python3

#import os
#import re
#import sys

# vimhelp -> html:
# - build any required tag files with runtime/doc/doctags
# - use builtin :TOhtml command (doc only, no css/header)
# - read tags file and insert href links in generated html
# - insert header, css ref, etc ...
# - include checksums of source files in generated html
# - implement generic way to include other things (i.e. vim_faq, ...)
# - command line args?
# - use template files

# Why not use the script runtime/doc/makehtml.awk that's made for this?:
# - turns many small words into links that shouldn't be (as, at, do, list, it, ...)
#   - could clean up via skip_words in makehtml.awk, but there are many words like this
# - screws up some formatting (see tables in pi_netrw.html ...)
# - adds tabs (even when all tabs were removed in source files first)
# - doesn't add any syntax css classes (style done via <a>, <b>, <font color="..."> ...)

# Why not use https://github.com/c4rlo/vimhelp?:
# - turns many small words into links that shouldn't be (as, at, do, list, it, ...)
# - doesn't render a static site (could be adapted to)

# vim -E -s -c "let g:html_no_progress=1" -c "syntax on" -c "set ft=c" -c "runtime syntax/2html.vim" -cwqa myfile.c
# g:html_no_doc = 1
# g:html_no_modeline = 1
# g:html_use_encoding = 'utf-8'
