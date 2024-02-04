vim9script
## snippets.vim ::

## ASCII ::
def TextAscii()
    if ! &modifiable
        return
    endif
    const pos = getpos('.')
    const textbuf = join(getline(1, '$'), "\n")
    const textnew = system('iconv -f utf-8 -t ascii//TRANSLIT', textbuf)
    if textbuf != textnew
        append(0, textnew)
        sil :1,$delete
        sil put =textnew
        :1delete
    endif
    setpos('.', pos)
enddef

nnoremap <leader>Ma <scriptcmd>TextAscii()<cr>

## Booleans ::
def BooleanToggle(bang = '')
    if ! &modifiable
        return
    endif
    var line0 = line('.')
    var line1 = line0
    if mode() ==? 'v'
        exec "normal! \<esc>"
        line0 = getpos("'<")[1]
        line1 = getpos("'>")[1]
    endif
    const booleans = [
        ["1", "0"],
        ["all", "none"],
        ["allow", "deny"],
        ["enable", "disable"],
        ["enabled", "disabled"],
        ["on", "off"],
        ["true", "false"],
        ["yes", "no"]
    ]
    var bools_all = []
    var bools_lower = []
    var bools_camel = []
    var bools_upper = []
    for b in booleans
        bools_lower = [tolower(b[0]), tolower(b[1])]
        bools_camel = [toupper(b[0][0]) .. b[0][1 : -1], toupper(b[1][0]) .. b[1][1 : -1]]
        bools_upper = [toupper(b[0]), toupper(b[1])]
        bools_all += [bools_lower]
        if bools_lower != bools_camel
            bools_all += [bools_camel]
        endif
        if bools_upper != bools_lower && bools_upper != bools_camel
            bools_all += [bools_upper]
        endif
    endfor
    var text0 = ''
    var text1 = ''
    var match = false
    for line in range(line0, line1)
        text0 = getline(line)
        text1 = ''
        for word in split(text0, '\(\<\|\>\)')
            match = false
            if match(word[0], '[0-1A-Za-z]') == 0
                for b in bools_all
                    for i in [0, 1]
                        if word == b[i]
                            text1 ..= b[(i + 1) % 2]
                            match = true
                            break
                        endif
                    endfor
                    if match
                        break
                    endif
                endfor
            endif
            if ! match
                text1 ..= word
            endif
        endfor
        if text0 != text1
            setline(line, text1)
        endif
    endfor
enddef

noremap <leader>b <scriptcmd>BooleanToggle()<cr>

## Comments ::
def CommentToggle(bang = '')
    if ! &modifiable
        return
    endif
    var line0 = line('.')
    var line1 = line0
    if mode() ==? 'v'
        exec "normal! \<esc>"
        line0 = getpos("'<")[1]
        line1 = getpos("'>")[1]
    endif
    const cmts = split(&commentstring, '%s')
    var cmt0 = '#'
    var cmt1 = ''
    if len(cmts) > 0
        cmt0 = substitute(substitute(escape(cmts[0], '*.\'),
          '\s\+', '', 'g'), '^\\\.\\\.', '\\\.\\\. ', '')
    endif
    if len(cmts) > 1
        cmt1 = substitute(escape(cmts[1], '*.\'), '\s\+', '', 'g')
    endif
    const regex_comment = '\(^\s*\)' .. cmt0 .. '\(.\{-}\)' .. cmt1 .. '\s*$'
    const regex_heading = '^\s*\(' .. cmt0 .. '\)\+\s.\{-}' .. cmt1 .. '\s*$'
    const sub_comment = '\1' .. cmt0 .. '\2' .. cmt1
    var text0 = ''
    var text1 = ''
    for line in range(line0, line1)
        text0 = getline(line)
        text1 = text0
        if match(text0, '^\s*$') >= 0 || match(text0, regex_heading) >= 0
          || (bang == '!' && cmt1 == '\*/')
            continue
        endif
        if bang == '!' || match(text0, regex_comment) < 0
            text1 = substitute(text0, '^\(\s*\)\(.\{-}\)\s*$', sub_comment, '')
        else
            text1 = substitute(text0, regex_comment, '\1\2\3', '')
        endif
        if text0 != text1
            setline(line, text1)
        endif
    endfor
enddef

noremap <leader>U <scriptcmd>CommentToggle('!')<cr>
noremap <leader>u <scriptcmd>CommentToggle()<cr>

## Headings ::
def HeadingPrint(bang = '')
    if ! &modifiable
        return
    endif
    redraw
    echon ''
    const nchar = char2nr(getcharstr())
    if nchar < 33 || nchar > 126
        return
    endif
    const line = line('.')
    const len = len(substitute(getline(line), '\s*$', '', ''))
    const hr = repeat(nr2char(nchar), len)
    append(line, hr)
    if ! empty(bang)
        append(line - 1, hr)
    endif
    setpos('.', [bufnr(), line + 1, len, 0])
enddef

nnoremap <leader>H <scriptcmd>HeadingPrint('!')<cr>
nnoremap <leader>h <scriptcmd>HeadingPrint()<cr>

## Indent Navigation ::
def IndentNav(move = ['next', 'same'])
    const line = getpos('.')[1]
    var linenew = line
    var indent = indent(line)
    var inc = 1
    if move[1] == 'more'
        indent = indent + &tabstop
    elseif move[1] == 'less'
        indent = indent - &tabstop
    endif
    if move[0] == 'prev'
        inc = -1
    endif
    while linenew <= line('$') && linenew >= 1
        linenew = linenew + inc
        if indent(linenew) == indent
            break
        endif
    endwhile
    if line != linenew && linenew <= line('$') && linenew >= 1
        setpos(".", [0, linenew, indent + 1, 0])
    endif
enddef

noremap <silent> [+ <scriptcmd>IndentNav(['prev', 'more'])<cr>
noremap <silent> [- <scriptcmd>IndentNav(['prev', 'less'])<cr>
noremap <silent> [= <scriptcmd>IndentNav(['prev', 'same'])<cr>
noremap <silent> ]+ <scriptcmd>IndentNav(['next', 'more'])<cr>
noremap <silent> ]- <scriptcmd>IndentNav(['next', 'less'])<cr>
noremap <silent> ]= <scriptcmd>IndentNav(['next', 'same'])<cr>

## Visual Mode ::
# TODO: rewrite with try/finally
def VisMode(mode = 'v')
    var nchar = 0
    var chars = ''
    var line = line('.')
    exec 'normal! ' .. mode
    while 1
        if mode() !=? 'v'
            if mode ==# 'v'
                normal! gv
            else
                normal! `>v`<
                if line('.') != line
                    normal! o
                endif
            endif
        endif
        redraw
        if mode ==# 'v'
            Msg('-- VISMODE --')
        else
            Msg('-- VISMODE LINE --')
        endif
        nchar = char2nr(getcharstr())
        if nchar == 27
            exec "normal \<esc>"
            redraw
            echon ''
            return
        endif
        if nchar == 105 || nchar == 97
            chars = nr2char(nchar)
            continue
        endif
        line = line('.')
        chars ..= nr2char(nchar)
        exec 'normal ' .. chars
        chars = ''
    endwhile
enddef

nnoremap <leader>wV <scriptcmd>VisMode('V')<cr>
nnoremap <leader>wv <scriptcmd>VisMode('v')<cr>

## Window Mode ::
def WinMode()
    var nchar = 0
    var chars = ''
    try
        while 1
            redraw
            Msg('-- WINMODE --')
            nchar = char2nr(getcharstr())
            if nchar == 27
                break
            endif
            chars ..= nr2char(nchar)
            if !(nchar == 103 || nchar == 71) && !(nchar > 47 && nchar < 58)
                exec 'normal ' .. nr2char(23) .. chars
                chars = ''
            endif
        endwhile
    finally
        redraw!
        echon ''
    endtry
enddef

nnoremap <leader><c-w> <scriptcmd>WinMode()<cr>

defcompile
