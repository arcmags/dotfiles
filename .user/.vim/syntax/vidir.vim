vim9script
## ~/.vim/syntax/vidir.vim ::

if exists('b:current_syntax')
    finish
endif

syntax match VidirNumber /^\d\+/
syntax match VidirComment /^#.*/
syntax match VidirSlash /\s\+\zs\.\//
syntax match VidirSlash /\//

hi def link VidirNumber Constant
hi def link VidirComment Comment
hi def link VidirSlash Special

b:current_syntax = 'vidir'
