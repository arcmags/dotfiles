vim9script
## ~/.vim/after/ftplugin/netrw.vim ::

## mappings ::
noremap <buffer> <c-w><c-e> <nop>
noremap <buffer> <c-w>E <nop>
noremap <buffer> <c-w>e <nop>
noremap <buffer> a <nop>
noremap <buffer> s <nop>

# close netrw and return to previous buffer:
nnoremap <buffer> <c-w><c-n> <cmd>BufLast!<cr>
nnoremap <buffer> <c-w>n <cmd>BufLast!<cr>
nnoremap <buffer> <c-n> <cmd>BufLast!<cr>
nnoremap <buffer> <c-w><c-p> <cmd>BufLast!<cr>
nnoremap <buffer> <c-w>p <cmd>BufLast!<cr>
nnoremap <buffer> <c-p> <cmd>BufLast!<cr>
nnoremap <buffer> <c-w><c-x> <cmd>BufLast!<cr>
nnoremap <buffer> <c-w>X <cmd>BufLast!<cr>
nnoremap <buffer> <c-w>x <cmd>BufLast!<cr>
nnoremap <buffer> <c-x> <cmd>BufLast!<cr>
nnoremap <buffer> <c-w>U <cmd>BufWipe!<cr><cmd>BufMatch<cr>
nnoremap <buffer> <c-w><c-u> <cmd>BufWipe<cr><cmd>BufMatch<cr>
nnoremap <buffer> <c-w>u <cmd>BufWipe<cr><cmd>BufMatch<cr>
nnoremap <buffer> <c-w>\ <cmd>terminal ++curwin ++noclose<cr>

# fast directory switching:
def CDMap(suffix = '', dir = '')
    execute 'nnoremap <buffer> <silent> cd' .. suffix .. ' '
      .. (isdirectory(dir) ? '<cmd>silent edit ' .. dir .. '<cr>' : '<nop>')
enddef
defcompile
CDMap('.', g:UDIR .. '/.user')
CDMap('<cr>', g:HOME)
CDMap('/', '/')
CDMap('b', g:UDIR .. '/bin')
CDMap('d', g:UDIR .. '/dat')
CDMap('g', g:UDIR .. '/git')
CDMap('l', g:UDIR .. '/local')
CDMap('m', '/mnt')
CDMap('n', '/mnt/nas')
CDMap('r', g:UDIR .. '/urepo')
CDMap('s', g:UDIR .. '/usync')
CDMap('t', g:TMPDIR)
CDMap('u', g:UDIR)
CDMap('w', g:UDIR .. '/www')
