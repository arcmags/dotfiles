vim9script
## ~/.vim/syntax/table.vim ::

if exists('b:current_syntax')
    finish
endif

syntax match TableComment /^#.*/
syntax match TableColumn1 /^.\{-}\s\s\+/me=e-2
syntax match TableColumn2 /\s\s.\{-}\s\s/me=e-2

hi def link TableComment Comment
hi def link TableColumn1 Type
hi def link TableColumn2 Statement

b:current_syntax = 'table'
