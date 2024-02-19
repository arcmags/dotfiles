vim9script
## ~/.vim/after/ftplugin/vidir.vim ::

setlocal commentstring=#%s
setlocal nonumber

nnoremap <buffer> <localleader>m 0wv$F/hxivideos_in/movies<esc>l
nnoremap <buffer> <localleader>M 0wv$F/hxivideos_in/movies/subs<esc>l
