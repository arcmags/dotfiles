vim9script
## ~/.vim/syntax/text.vim ::

if exists('b:current_syntax')
    finish
endif

syntax match TextComment /^#.*/

hi def link TextComment Comment

b:current_syntax = 'text'
