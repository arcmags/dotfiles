vim9script
## temp.vim ::

# {normal}<mapping>
def FuncNorm()
    setline(line('.'), '#' .. getline(line('.')))
enddef
nnoremap <leader>fa <scriptcmd>FuncNorm()<cr>

# {normal}[count]<mapping>
# operate [count] times on  current line:
def FuncNormCount()
    setline(line('.'), repeat('#', v:count1) .. getline(line('.')))
enddef
nnoremap <leader>fb <scriptcmd>FuncNormCount()<cr>

# {normal|visual}[count]<mapping>
# operation can be repeated .
def FuncNormVisCount(count = 1, mode = '')
    if empty(mode)
        &opfunc = function('FuncNormVisCount', [v:count1])
        return
    endif
    var line0 = getpos("'[")[1]
    var line1 = getpos("']")[1]
    for line in range(line0, line1)
        setline(line, repeat('#', count) .. getline(line))
    endfor
enddef
nnoremap <leader>M5 <scriptcmd>FuncNormVisCount()<cr>g@_
vnoremap <leader>M5 <scriptcmd>FuncNormVisCount()<cr>g@_

# {normal}[count]<mapping><suffix>
# {visual}[count]<mapping>
# {normal}[count]<mapping>[count]<motion>
# pass first [count] to function, pass second [count] to motion:
def FuncNormVisCountMotion(count = 1, mode = '')
    if empty(mode)
        &opfunc = function('FuncNormVisCountMotion', [v:count1])
        return
    endif
    var line0 = getpos("'[")[1]
    var line1 = getpos("']")[1]
    for line in range(line0, line1)
        setline(line, repeat('#', count) .. getline(line))
    endfor
enddef
nnoremap <leader>M9 <scriptcmd>FuncNormVisCountMotion()<cr>g@
vnoremap <leader>M9 <scriptcmd>FuncNormVisCountMotion()<cr>g@_
#vnoremap <leader>M9 <scriptcmd>FuncNormVisCountMotion()<cr>g@
nnoremap <leader>M9m <scriptcmd>FuncNormVisCountMotion()<cr>g@_

defcompile
