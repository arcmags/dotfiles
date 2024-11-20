vim9script
## srt.vim - filetype plugin for working with subtitle files ::
# maintainer: Chris Magyar <c.magyar.ec@gmail.com>
# updated: 2024-11-17

if !exists('g:srt_maps') || g:srt_maps
    nnoremap <buffer> <localleader>m <scriptcmd>SRTClean()<cr>
    nnoremap <buffer> <localleader>n <scriptcmd>SRTNumber()<cr>
endif

command! -nargs=1 MsToTime MsToTimeCmd(<f-args>)
command! -nargs=1 TimeToMs TimeToMsCmd(<f-args>)
command! SRTClean SRTClean()
command! SRTNumber SRTNumber()
command! -nargs=1 SRTShift SRTShift(<f-args>)
command! -bang -nargs=* SRTSkew SRTSkew(<q-bang>, <f-args>)
command! -range SRTToAscii SRTToAscii('n', <line1>, <line2>)

# TODO: functions to remove <font color>, <b>, <i>, alignments?

def MsToTime(ms: number): string
    # convert milliseconds to timestamp:
    var parts = []
    var tmp_ms = ms
    for n in [3600000, 60000, 1000]
        parts += [tmp_ms / n]
        tmp_ms = tmp_ms % n
    endfor
    return printf('%02d:%02d:%02d,%03d', parts[0], parts[1], parts[2], tmp_ms)
enddef

def MsToTimeCmd(arg: string)
    echo MsToTime(str2nr(arg))
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

def TimeToMsCmd(arg: string)
    echo TimeToMs(arg)
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
    # TODO: instead of all this, parse subtitles as objects?
    # TODO: populate scan/warn/error results in quickfix window?
    # strip trailing whitespaces:
    sil keepp :%s/\s\+$//e
    # merge repeated blank lines:
    sil! keepp g/^\n\{2,}/d
    # remove trailing blank lines:
    sil keepp :%s/\($\n\s*\)\+\%$//e
    # remove leading blank lines:
    sil keepp :%s/\%^\n\+//e
    # fix incorrect timestamp arrows:
    sil keepp :%s/^\(\d\+:\d\d:\d\d,\d\d\d\)\s*\(\|-\|---\+\)>\+\s*\(\d\+:\d\d:\d\d,\d\d\d\)$/\1 --> \3/e
    # remove blank lines between indexes and timecodes:
    sil keepp :%s/\(\%^\|\n\)\(\d\+\n\)\n\+/\1\2/e
    # remove blank lines between timecodes and text:
    sil keepp :%s/^\(\d\+:\d\d:\d\d,\d\d\d --> \d\+:\d\d:\d\d,\d\d\d\n\)\n\+\([^0-9]\+\)$/\1\2/e
    # remove blank lines between text:
    sil keepp :%s/\(\n\)\n\+\([^0-9]\)/\1\2/e
    # add missing space after leading dashes:
    sil keepp :%s/^-\([^ -]\)/- \1/e
    # make every utf-8 note character an eighth note:
    sil keepp :%s/[\u2669\u266b\u266c]\+/\=nr2char(0x266a)/ge
    # merge repeated eighth notes and pound symbols, remove extra spaces:
    sil keepp :%s/\([\u266a#]\) \+[\u266a#]\+/\1/ge
    sil keepp :%s/\([\u266a#]\)[\u266a#]\+/\1/ge
    sil keepp :%s/\([\u266a#]\)  \+/\1 /ge
    sil keepp :%s/  \+\([\u266a#]\)/ \1/ge
    # add missing space after eighth note or pound symbol at start of lines:
    sil keepp :%s/^\([\u266a#]\)\([^ ]\)/\1 \2/ge
    # add missing space before eigth note or pound symbol at end of lines:
    sil keepp :%s/^\(.\+\)\([^ ]\)\([\u266a#]\)$/\1\2 \3/ge
    # remove lines with only eigth notes or pound symbols:
    sil! keepp g/^[#\u266a]$/d
    # remove blank subtitles:
    sil! keepp g/^\d\+\n\d\d:\d\d:\d\d,\d\d\d --> \d\d:\d\d:\d\d,\d\d\d\n^$/d 3
    # strip trailing whitespaces:
    sil keepp :%s/\s\+$//e
    # merge repeated blank lines:
    sil! keepp g/^\n\{2,}/d
    # remove trailing blank lines:
    sil keepp :%s/\($\n\s*\)\+\%$//e
    # remove leading blank lines:
    sil keepp :%s/\%^\n\+//e
    # renumber subtitles:
    SRTNumber()
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

def SRTShift(ms: string)
    # shift subtitle timecode by milliseconds:
    const s = str2nr(ms)
    var text0 = ''
    var times = []
    for line in range(1, line('$'))
        text0 = getline(line)
        if match(text0, '^\d\+:\d\d:\d\d,\d\d\d --> \d\+:\d\d:\d\d,\d\d\d$') >= 0
            times = split(text0, ' --> ')
            map(times, (key, val) => MsToTime(TimeToMs(val) + s))
            silent setline(line, times[0] .. ' --> ' .. times[1])
        endif
    endfor
enddef

def SRTSkew(bang: string, st1: string, ss1: string, st2: string, ss2: string)
    const t1 = TimeToMs(st1)
    const s1 = str2nr(ss1)
    const t2 = TimeToMs(st2)
    const s2 = str2nr(ss2)
    var m = ((t2 + s2) - (t1 + s1)) / (t2 - t1 + 0.0)
    var b = t1 + s1 - m * t1
    var text0 = ''
    var times = []
    if bang == '!'
        m = (t2 - t1) / ((t2 - s2) - (t1 - s1) + 0.0)
        b = t1 + s1 - m * t1
    endif
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
    const subs = [['[\u2669\u266a\u266b\u266c]', '#']]
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

# vim:set sw=4
