vim9script
## ~/.vim/after/ftplugin/netrw.vim ::

## mappings ::
noremap <buffer> <c-w><c-e> <nop>
noremap <buffer> <c-w>E <nop>
noremap <buffer> <c-w>e <nop>
noremap <buffer> a <nop>
noremap <buffer> s <nop>

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
CDMap('p', g:UDIR .. '/dat/python')
CDMap('r', g:UDIR .. '/urepo')
CDMap('s', g:UDIR .. '/usync')
CDMap('t', g:TMPDIR)
CDMap('u', g:UDIR)
CDMap('w', g:UDIR .. '/www')
