vim9script
## ~/.vim/after/ftplugin/vidir.vim ::

setlocal commentstring=#%s
setlocal nonumber

var dir_videos = isdirectory($HOME) ? resolve($HOME) .. '/videos' : 'videos'
if exists('g:vidir_dir_videos')
    dir_videos = g:vidir_dir_videos
endif

nnoremap <buffer> <expr> <localleader>m '<cmd>s#^\(\d\+\s\+\)\(.*/\)\?\(.*\)#\1' .. dir_videos .. '/movies/\3<cr>'
nnoremap <buffer> <expr> <localleader>M '<cmd>s#^\(\d\+\s\+\)\(.*/\)\?\(.*\)#\1' .. dir_videos .. '/movies/subs/\3<cr>'
nnoremap <buffer> <expr> <localleader>s '<cmd>s#^\(\d\+\s\+\)\(.*/\)\?\(.*\)#\1' .. dir_videos .. '/shows/\3<cr>'
nnoremap <buffer> <expr> <localleader>S '<cmd>s#^\(\d\+\s\+\)\(.*/\)\?\(.*\)#\1' .. dir_videos .. '/shows/subs\3<cr>'
