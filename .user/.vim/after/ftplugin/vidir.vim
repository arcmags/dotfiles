vim9script
## ~/.vim/after/ftplugin/vidir.vim ::

setlocal commentstring=#%s
setlocal nonumber

var dir_videos = isdirectory($HOME) ? resolve($HOME) .. '/videos' : 'videos'
if exists('g:vidir_dir_videos')
    dir_videos = g:vidir_dir_videos
endif

nnoremap <buffer> <expr> <localleader>m '0wv$F/hxi' .. dir_videos .. '/movies<esc>l'
nnoremap <buffer> <expr> <localleader>M '0wv$F/hxi' .. dir_videos .. '/movies/subs<esc>l'
nnoremap <buffer> <expr> <localleader>s '0wv$F/hxi' .. dir_videos .. '/shows<esc>l'
nnoremap <buffer> <expr> <localleader>S '0wv$F/hxi' .. dir_videos .. '/shows/subs<esc>l'
