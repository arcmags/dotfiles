vim9script
## srt.vim - filetype plugin for working with subtitle files ::
# maintainer: Chris Magyar <c.magyar.ec@gmail.com>
# updated: 2024-10-26

if !exists('g:srt_maps') || g:srt_maps
    nnoremap <buffer> <localleader>m <scriptcmd>SRTClean()<cr>
    nnoremap <buffer> <localleader>n <scriptcmd>SRTNumber()<cr>
endif

command! SRTClean SRTClean()
command! SRTNumber SRTNumber()
command! -nargs=1 SRTShift SRTShift(<args>)
command! -bang -nargs=* SRTSkew SRTSkewCmd(<q-bang>, <f-args>)
command! -range SRTToAscii SRTToAscii('n', <line1>, <line2>)

# TODO: functions to remove <font color>, <b>, <i>?
# TODO: function to skew timestamps

def MsToTime(ms: number): string
    # convert milliseconds to timestamp:
    var parts = []
    parts[0] = ms / 3600000
    var tmp_ms = ms % 3600000
    parts[1] = tmp_ms / 60000
    tmp_ms = tmp_ms % 60000
    parts[2] = tmp_ms / 1000
    tmp_ms = tmp_ms % 1000
    parts[3] = tmp_ms
    return printf('%02d:%02d:%02d,%03d', parts[0], parts[1], parts[2], parts[3])
enddef

def TimeToMs(time: string): number
    # convert timestamp to milliseconds:
    var ms = 0
    var parts = []
    var time_tmp = time
    if match(time, '[,.]') >= 0
        ms = str2nr(substitute(time, '^[^,.]*[,.]', '', ''))
        time_tmp = substitute(time, '[,.].*$', '', '')
    endif
    parts = split(time_tmp, ':')
    map(parts, (key, val) => str2nr(val))
    if len(parts) == 1
        ms = ms + parts[0] * 1000
    elseif len(parts) == 2
        ms = ms + parts[0] * 60000 + parts[1] * 1000
    elseif len(parts) == 3
        ms = ms + parts[0] * 3600000 + parts[1] * 60000 + parts[2] * 1000
    endif
    return ms
enddef

def SRTClean()
    const pos = getpos('.')
    # remove carriage returns, convert to unix:
    if !exists('g:srt_unix') || g:srt_unix
        sil keepp :%s/\r//e
        sil setlocal fileformat=unix nobomb
    endif
    # convert to utf-8:
    if !exists('g:srt_utf8') || g:srt_utf8
        sil keepp :%s/\r//e
        sil setlocal fileencoding=utf-8
    endif
    # replace tabs with spaces:
    if !exists('g:srt_tabs') || !g:srt_tabs
        setlocal expandtab
        retab
    endif
    # strip trailing whitespaces:
    sil keepp :%s/\s\+$//e
    # merge repeated blank lines:
    sil! keepp g/^\n\{2,}/d
    # remove trailing blank lines:
    sil keepp :%s/\($\n\s*\)\+\%$//e
    # remove leading blank lines:
    sil keepp :%s/\%^\n\+//e
    # fix timestamps with bad syntax:
    sil keepp :%s/^\(\d\+:\d\d:\d\d,\d\d\d\)\s*-\?>\+\s*\(\d\+:\d\d:\d\d,\d\d\d\)$/\1 --> \2/e
    sil keepp :%s/^\(\d\+:\d\d:\d\d,\d\d\d\)\s*---\+>\+\s*\(\d\+:\d\d:\d\d,\d\d\d\)$/\1 --> \2/e
    # remove blank lines between indexes and timecodes:
    sil keepp :%s/\(\%^\|\n\)\(\d\+\n\)\n/\1\2/e
    # remove blank lines between timecodes and text:
    sil keepp :%s/^\(\d\+:\d\d:\d\d,\d\d\d --> \d\+:\d\d:\d\d,\d\d\d\n\)\n/\1/e
    # add missing space after leading dashes:
    sil keepp :%s/^-\([^ -]\)/- \1/e
    # make every utf-8 note character an eighth note:
    sil keepp :%s/[\d9833\d9834\d9835\d9836]\+/\=nr2char(9834)/ge
    # merge repeated eighth notes:
    sil keepp :%s/\%d9834[\d9834 ]\{-}\%d9834/\=nr2char(9834)/ge
    # add missing space before eighth notes at ends of lines:
    sil keepp :%s/^\(.\+\)\([^ ]\)\(\%d9834\)$/\1\2 \3/ge
    # merge repeated pound symbols:
    sil keepp :%s/#[# ]\{-}#/#)/ge
    # add missing space before pound symbols at ends of lines:
    sil keepp :%s/^\(.\+\)\([^ ]\)#$/\1\2 #/ge
    # renumber subtitles:
    call SRTNumber()
    setpos('.', pos)
enddef

def SRTNumber()
    # renumber subtitles:
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

def SRTShift(ms_shift: number)
    # shift subtitle timecode by milliseconds:
    var text0 = ''
    var times = []
    var ms = 0
    for line in range(1, line('$'))
        text0 = getline(line)
        if match(text0, '^\d\+:\d\d:\d\d,\d\d\d --> \d\+:\d\d:\d\d,\d\d\d$') >= 0
            times = split(text0, ' --> ')
            map(times, (key, val) => MsToTime(TimeToMs(val) + ms_shift))
            silent setline(line, times[0] .. ' --> ' .. times[1])
        endif
    endfor
enddef

def SRTSkewCmd(bang: string, t1: string, s1: string, t2: string, s2: string)
    # command wrapper for SRTSkew:
    if bang == '!'
        SRTSkew(TimeToMs(t1) - str2nr(s1), str2nr(s1), TimeToMs(t2) - str2nr(s2), str2nr(s2))
    else
        SRTSkew(TimeToMs(t1), str2nr(s1), TimeToMs(t2), str2nr(s2))
    endif
enddef

def SRTSkew(t1: number, s1: number, t2: number, s2: number)
    # skew subtitle timecodes:
    var text0 = ''
    var times = []
    const m = ((t2 + s2) - (t1 + s1)) / (t2 - t1 + 0.0)
    const b = t1 + s1 - m * t1
    for line in range(1, line('$'))
        text0 = getline(line)
        if match(text0, '^\d\+:\d\d:\d\d,\d\d\d --> \d\+:\d\d:\d\d,\d\d\d$') >= 0
            times = split(text0, ' --> ')
            for i in [0, 1]
                times[i] = MsToTime(float2nr(m * TimeToMs(times[i]) + b))
            endfor
            silent setline(line, times[0] .. ' --> ' .. times[1])
        endif
    endfor
enddef

def SRTToAscii(mode = 'n', start = -1, end = -1)
    # convert to ASCII with transliteration:
    if !executable('iconv')
        echohl WarningMsg
        echomsg "W: required program 'iconv' not found, no changes made"
        echohl none
        return
    endif
    const subs = [['[\d9833\d9834\d9835\d9836]', '#']]
    var line0 = line('.')
    var line1 = line0
    if mode == 'v'
        exec "normal! \<esc>"
        line0 = getpos("'<")[1]
        line1 = getpos("'>")[1]
    elseif start > 0
        line0 = start
        line1 = end
    endif
    const lines = getline(line0, line1)
    var text = join(lines, "\n")
    for sub in subs
        text = substitute(text, sub[0], sub[1], 'g')
    endfor
    const linesnew = split(system('iconv -f utf-8 -t ascii//TRANSLIT', text), "\n")
    for i in range(len(linesnew))
        if lines[i] != linesnew[i]
            setline(line0 + i, linesnew[i])
        endif
    endfor
enddef

defcompile

# vim:et sw=4
