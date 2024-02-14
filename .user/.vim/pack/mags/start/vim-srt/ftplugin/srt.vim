vim9script
## srt.vim - filetype plugin for working with subtitle files ::
# maintainer: Chris Magyar <c.magyar.ec@gmail.com>
# updated: 2024-02-13

if !exists('g:srt_maps') || g:srt_maps
    nnoremap <buffer> <localleader>m <scriptcmd>SRTClean()<cr>
    nnoremap <buffer> <localleader>n <scriptcmd>SRTNumber()<cr>
endif

command! SRTClean SRTClean()
command! SRTNumber SRTNumber()
command! -nargs=1 SRTShift SRTShift(<args>)
command! -range SRTToAscii SRTToAscii('n', <line1>, <line2>)

def SRTClean()
    # remove carriage returns, convert to utf-8 unix, strip trailing
    # whitespaces, remove leading/trailing blank lines, combine multiple blank
    # lines, fix syntax errors, replace tabs with spaces, re-number subtitles:
    const pos = getpos('.')
    if !exists('g:srt_unix') || g:srt_unix
        sil keepp :%s/\r//e
        sil setlocal fileformat=unix nobomb
    endif
    if !exists('g:srt_utf8') || g:srt_utf8
        sil keepp :%s/\r//e
        sil setlocal fileencoding=utf-8
    endif
    if !exists('g:srt_tabs') || !g:srt_tabs
        setlocal expandtab
        retab
    endif
    sil keepp :%s/\s\+$//e
    sil keepp :%s/\($\n\s*\)\+\%$//e
    sil keepp :%s/\%^\n\+//e
    sil! keepp g/^\n\{2,}/d
    sil keepp :%s/^\(\d\+:\d\d:\d\d,\d\d\d\)\s*-\?>\+\s*\(\d\+:\d\d:\d\d,\d\d\d\)$/\1 --> \2/e
    sil keepp :%s/^\(\d\+:\d\d:\d\d,\d\d\d\)\s*---\+>\+\s*\(\d\+:\d\d:\d\d,\d\d\d\)$/\1 --> \2/e
    sil keepp :%s/\(\%^\|\n\)\(\d\+\n\)\n/\1\2/e
    sil keepp :%s/^\(\d\+:\d\d:\d\d,\d\d\d --> \d\+:\d\d:\d\d,\d\d\d\n\)\n/\1/e
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

def SRTToAscii(mode = 'n', start = -1, end = -1)
    # convert to ASCII with transliteration:
    if !executable('iconv')
        echohl WarningMsg
        echomsg "W: required program 'iconv' not found, no changes made"
        echohl none
        return
    endif
    const subs = [
        ["\u2669", '#'],
        ["\u266a", '#'],
        ["\u266b", '#'],
        ["\u266c", '#']
    ]
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
