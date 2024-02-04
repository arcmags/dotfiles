vim9script
## ~/.vim/after/ftplugin/vidir.vim ::

setlocal commentstring=#%s
setlocal nonumber

nnoremap <buffer> <leader>vm 0wv$F/hxivideos_in/movies<esc>
nnoremap <buffer> <leader>vM 0wv$F/hxivideos_in/movies/subs<esc>
nnoremap <buffer> <leader>vs 0wv$F/F/hxivideos_in/shows<esc>
nnoremap <buffer> <leader>vS 0wv$F/F/hxivideos_in/shows<esc>f/asubs/<esc>
