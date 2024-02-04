vim9script
## ~/.vim/plugin/test.vim ::

# The snippets below demonstrate various ways counts, ranges, and
# motions can be passed to or used in vim9script functions.

# Counts, motions, ranges are up to the function to determine what to do with.
# I'll compare operations to how builtin mappings work and show various
# different ways things can be done.

## key ::
# {}:  mode
# []: optional input
# <>: required input

# {normal}<mapping>
def FuncNormLine()
    setline(line('.'), '#' .. getline(line('.')))
enddef
nnoremap <leader>fl <scriptcmd>FuncNormLine()<cr>

# {normal}[count]<mapping>
# operate [count] times on  current line:
def FuncNorm0()
    setline(line('.'), repeat('#', v:count1) .. getline(line('.')))
enddef
nnoremap <leader>fn <scriptcmd>FuncNorm0()<cr>

# {normal}[count]<mapping>
# operate on [count] lines:
def FuncNorm1()
    for line in range(line('.'), line('.') + v:count1 - 1)
        setline(line, '#' .. getline(line))
    endfor
enddef
nnoremap <leader>fN <scriptcmd>FuncNorm1()<cr>

# {normal}[count]<mapping>
# operate on current line, operation dependent on [count]:
def FuncNorm2()
    const line = line('.')
    setline(line('.'), repeat(nr2char(v:count1 % 94 + 33), 8))
enddef
nnoremap <leader>Fn <scriptcmd>FuncNorm2()<cr>

# operate [count] times on current line:
# operation can be repeated with .
def FuncNorm3(vcount = 1, mode = '')
    if empty(mode)
        &opfunc = function('FuncNorm3', [v:count1])
        return
    endif
    setline(line('.'), repeat('#', vcount * v:count1) .. getline(line('.')))
enddef
nnoremap <leader>FN <scriptcmd>FuncNorm3()<cr>g@_

# {normal}[count]<mapping>
# operate on [count] lines:
# operation can be repeated .
def FuncNorm4(vcount = 1, mode = '')
    if empty(mode)
        &opfunc = function('FuncNorm4', [v:count1])
        return
    endif
    for line in range(line('.'), line('.') + vcount - 1)
        setline(line, '#' .. getline(line))
    endfor
enddef
nnoremap <leader>Fm <scriptcmd>FuncNorm4()<cr>g@_

# {normal|visual}[count]<mapping>
def FuncNormVis(mode = 'n')
    const count = v:count1
    var line0 = line('.')
    var line1 = line0
    if mode == 'v' || mode() ==? 'v' || mode() == "\<c-v>"
        exec "normal! \<esc>"
        line0 = getpos("'<")[1]
        line1 = getpos("'>")[1]
    endif
    for line in range(line0, line1)
        setline(line, repeat('#', count) .. getline(line))
    endfor
enddef
nnoremap <leader>M4 <scriptcmd>FuncNormVis()<cr>
vnoremap <leader>M4 <scriptcmd>FuncNormVis('v')<cr>

# {normal|visual}[count]<mapping>
# operation can be repeated .
def FuncNormVis2(count = 1, mode = '')
    if empty(mode)
        &opfunc = function('FuncNormVis2', [v:count1])
        return
    endif
    var line0 = getpos("'[")[1]
    var line1 = getpos("']")[1]
    for line in range(line0, line1)
        setline(line, repeat('#', count) .. getline(line))
    endfor
enddef
nnoremap <leader>M5 <scriptcmd>FuncNormVis2()<cr>g@_
vnoremap <leader>M5 <scriptcmd>FuncNormVis2()<cr>g@_

# {normal}[count]<mapping>[count]<motion>
# multiply [counts] and pass to both function and motion:
def FuncOp(mode = ''): string
    if empty(mode)
        set opfunc=FuncOp
        return 'g@'
    endif
    var line0 = getpos("'[")[1]
    var line1 = getpos("']")[1]
    for line in range(line0, line1)
        setline(line, repeat('#', v:count1) .. getline(line))
    endfor
    return ''
enddef
nnoremap <expr> <leader>M6 FuncOp()

# {normal}[count]<mapping>[count]<motion>
# pass first [count] to function, pass second [count] to motion:
def FuncOp2(count = 1, mode = '')
    if empty(mode)
        &opfunc = function('FuncOp2', [v:count1])
        return
    endif
    var line0 = getpos("'[")[1]
    var line1 = getpos("']")[1]
    for line in range(line0, line1)
        setline(line, repeat('#', count) .. getline(line))
    endfor
enddef
nnoremap <leader>M7 <scriptcmd>FuncOp2()<cr>g@

# {normal}[count]<mapping>[count]<motion>
# if first [count] = 1, wait for [motion]:
# if first [count] > 1, [count] lines downward as motion
# multiply [counts], pass to function and motion:
def FuncOp3(mode = ''): string
    if empty(mode)
        set opfunc=FuncOp3
        if v:count1 == 1
            return 'g@'
        else
            return 'g@g@'
        endif
    endif
    var line0 = getpos("'[")[1]
    var line1 = getpos("']")[1]
    for line in range(line0, line1)
        setline(line, repeat('#', v:count) .. getline(line))
    endfor
    return ''
enddef
nnoremap <expr> <leader>M8 FuncOp3()

# {normal}[count]<mapping><suffix>
# {visual}[count]<mapping>
# {normal}[count]<mapping>[count]<motion>
# pass first [count] to function, pass second [count] to motion:
def FuncNormVisOp(count = 1, mode = '')
    if empty(mode)
        &opfunc = function('FuncNormVisOp', [v:count1])
        return
    endif
    var line0 = getpos("'[")[1]
    var line1 = getpos("']")[1]
    for line in range(line0, line1)
        setline(line, repeat('#', count) .. getline(line))
    endfor
enddef
nnoremap <leader>M9 <scriptcmd>FuncNormVisOp()<cr>g@
vnoremap <leader>M9 <scriptcmd>FuncNormVisOp()<cr>g@_
#vnoremap <leader>M9 <scriptcmd>FuncNormVisOp()<cr>g@
nnoremap <leader>M9m <scriptcmd>FuncNormVisOp()<cr>g@_

defcompile
