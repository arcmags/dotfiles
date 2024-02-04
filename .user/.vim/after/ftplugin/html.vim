vim9script
## ~/.vim/after/ftplugin/html.vim ::

setlocal shiftwidth=2 tabstop=2
setlocal makeprg=tidy\ -q\ --gnu-emacs\ true\ --markup\ false\ %\ 2>&1\ \\\|\ sort
