vim9script
## ~/.vim/plugin/ucomment.vim ::

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

noremap <leader>C <scriptcmd>CommentToggle('!')<cr>
noremap <leader>c <scriptcmd>CommentToggle()<cr>
