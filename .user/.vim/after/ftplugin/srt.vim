vim9script
## ~/.vim/after/ftplugin/srt.vim ::
# TODO: help doc
# TODO: SRTCheck function, maybe populate the quick/local list with errors?
# TODO: maybe run check automatically on opened files?
# TODO: maybe throw format/syntax errors/warnings in functions below

nnoremap <buffer> <localleader>n <scriptcmd>SRTNumber()<cr>

command! SRTNumber SRTNumber()
command! -nargs=1 SRTShift SRTShift(<q-args>)

def SRTNumber()
    # TODO: SRTRenumber() instead?
    var c = 1
    var text0 = ''
    var text1 = ''
    for line in range(1, line('$'))
        text0 = getline(line)
        if match(text0, '^\d\+$') >= 0
            text1 = string(c)
            if text0 != text1
                silent setline(line, text1)
            endif
            c = c + 1
        endif
    endfor
enddef

def SRTShift(arg: string)
    # TODO: more arg, error checking
    var ms_shift = 0
    try
        ms_shift = str2nr(arg)
    catch
        return
    endtry
    if ms_shift == 0
        return
    endif
    var text0 = ''
    var times = []
    var ms = 0
    var parts = []
    for line in range(1, line('$'))
        text0 = getline(line)
        if match(text0, '^\d\+:\d\d:\d\d,\d\d\d --> \d\+:\d\d:\d\d,\d\d\d$') >= 0
            times = split(text0, ' --> ')
            for i in [0, 1]
                parts = split(times[i], ':')
                parts += [split(parts[2], ',')[1]]
                parts[2] = split(parts[2], ',')[0]
                map(parts, (key, val) => str2nr(val))
                ms = parts[0] * 3600000 + parts[1] * 60000 + parts[2] * 1000 + parts[3]
                ms = ms + ms_shift
                parts[0] = ms / 3600000
                ms = ms % 3600000
                parts[1] = ms / 60000
                ms = ms % 60000
                parts[2] = ms / 1000
                ms = ms % 1000
                parts[3] = ms
                times[i] = printf('%02d:%02d:%02d,%03d', parts[0], parts[1], parts[2], parts[3])
            endfor
            silent setline(line, times[0] .. ' --> ' .. times[1])
        endif
    endfor
enddef

defcompile
