vim9script
## ~/.vim/colors/utheme.vim  ::

set background=dark
set notermguicolors
set t_Co=16
hi clear
if exists("syntax_on")
	syntax reset
endif
g:colors_name = "utheme"

hi Normal ctermfg=07 ctermbg=00 cterm=none term=none
hi Bold cterm=bold term=bold
hi Italic ctermfg=15 cterm=none term=none

## UI ::
hi ColorColumn ctermbg=05 cterm=none term=none
hi Cursor ctermfg=00 ctermbg=07 cterm=none term=none
hi CursorColumn ctermbg=05 cterm=none term=none
hi CursorLine ctermbg=05 cterm=none term=none
hi CursorLineNr ctermfg=10 ctermbg=05 cterm=bold term=bold
hi Directory ctermfg=12 cterm=bold term=bold
hi FoldColumn ctermfg=08 ctermbg=00 cterm=bold term=bold
hi Folded ctermfg=08 ctermbg=00 cterm=bold term=bold
hi LineNr ctermfg=04 ctermbg=00 cterm=none term=none
hi NonText ctermfg=04 cterm=none term=none
hi SignColumn ctermfg=07 ctermbg=00 cterm=none term=none
hi VertSplit ctermfg=04 ctermbg=04 cterm=none term=none
hi Visual ctermfg=none ctermbg=04

# statusline:
hi StatusLine ctermfg=10 ctermbg=04 cterm=bold term=bold
hi StatusLineLen ctermfg=03 ctermbg=04 cterm=none term=none
hi StatusLineNC ctermfg=07 ctermbg=04 cterm=none term=none
hi StatusLinePath ctermfg=12 ctermbg=04 cterm=bold term=bold
hi StatusLinePct ctermfg=11 ctermbg=04 cterm=none term=none
hi StatusLineSep ctermfg=08 ctermbg=04 cterm=bold term=bold
hi StatusLineBranch ctermfg=13 ctermbg=04 cterm=none term=none
hi StatusLineType ctermfg=12 ctermbg=04 cterm=none term=none
hi! link StatusLineTerm StatusLine
hi! link StatusLineTermNC StatusLineNC

# tabline:
hi! link TabLine StatusLineNC
hi! link TabLineFill StatusLineNC
hi! link TabLineSel StatusLine
hi! link helpOption String
hi! link TabLineSep StatusLineSep

# menu:
hi Pmenu ctermfg=07 ctermbg=05 cterm=none term=none
hi PmenuSbar ctermfg=07 ctermbg=05 cterm=none term=none
hi PmenuSel ctermfg=10 ctermbg=04 cterm=none term=none
hi PmenuThumb ctermfg=10 ctermbg=04 cterm=none term=none
hi WildMenu ctermfg=10 ctermbg=04 cterm=bold term=bold

# message:
hi ErrorMsg ctermfg=09 ctermbg=00 cterm=bold term=bold
hi InfoMsg ctermfg=07 ctermbg=00 cterm=none term=none
hi ModeMsg ctermfg=10 ctermbg=00 cterm=bold term=bold
hi MoreMsg ctermfg=10 ctermbg=00 cterm=bold term=bold
hi Question ctermfg=14 ctermbg=00 cterm=none term=none
hi TOhtmlProgress ctermbg=02 cterm=none term=none
hi Title ctermfg=12 ctermbg=00 cterm=bold term=bold
hi WarningMsg ctermfg=11 ctermbg=00 cterm=bold term=bold

# diff:
hi DiffAdd ctermbg=02 cterm=none term=none
hi DiffChange ctermbg=00 cterm=none term=none
hi DiffDelete ctermbg=01 cterm=none term=none
hi DiffText ctermbg=02 cterm=none term=none

# search:
hi CurSearch ctermfg=11 ctermbg=04 cterm=none term=none
hi IncSearch ctermfg=11 ctermbg=04 cterm=none term=none
hi Search ctermfg=03 ctermbg=04 cterm=none term=none

# spell:
hi SpellBad ctermfg=09 ctermbg=04 cterm=none term=none
hi SpellCap ctermfg=03 ctermbg=04 cterm=none term=none
hi SpellLocal ctermfg=01 ctermbg=04 cterm=none term=none
hi SpellRare ctermfg=01 ctermbg=04 cterm=none term=none

## syntax ::
hi Comment ctermfg=08 cterm=none term=none
hi Conceal ctermfg=08 cterm=none term=none
hi Constant ctermfg=03 cterm=none term=none
hi Debug ctermfg=09 cterm=none term=none
hi Delimiter ctermfg=13 cterm=bold term=bold
hi Error ctermfg=09 ctermbg=00 cterm=bold term=bold
hi Identifier ctermfg=14 cterm=none term=none
hi Ignore ctermfg=04 cterm=none term=none
hi MatchParen ctermbg=08 cterm=bold term=bold
hi PreProc ctermfg=11 cterm=none term=none
hi Special ctermfg=06 cterm=none term=none
hi SpecialKey ctermfg=06 cterm=none term=none
hi Statement ctermfg=13 cterm=none term=none
hi String ctermfg=10 cterm=none term=none
hi Todo ctermfg=11 ctermbg=00 cterm=bold term=bold
hi Type ctermfg=12 cterm=none term=none
hi Underlined ctermfg=14 cterm=none term=none
hi Strong ctermfg=15 cterm=bold term=bold
hi Separator ctermfg=08 cterm=bold term=bold

# asciidoc:
hi! link asciidocQuotedBold Strong
hi! link asciidocQuotedEmphasized Italic
hi! link asciidocLiteralParagraph String
hi! link asciidocMacro Statement
hi! link asciidocUrl Statement
hi! link asciidocMacroAttributes Identifier

# bash:
hi! link bashSpecialVariables Type

# cfg:
hi! link CfgSection Title
hi! link CfgValues Statement
hi! link CfgOnOff Constant

# css:
hi! link cssBraces Delimiter

# help:
hi! link helpSectionDelim Separator
hi! link helpHeader Title
hi! link helpHeadline Title
hi! link helpHyperTextEntry Title

# html:
hi! link htmlBold Strong
hi! link htmlBoldItalic htmlBold
hi! link htmlBoldUnderlineItalic htmlBold
hi! link htmlEndTag Delimiter
hi! link htmlEndTag Delimiter
hi! link htmlItalic Italic
hi! link htmlTag Delimiter
hi! link htmlUnderlineItalic htmlBold

# json:
hi! link jsonBoolean PreProc
hi! link jsonKeyword Type
hi! link jsonNull Special

# man:
hi! link manSectionHeading Title
hi! link manSubHeading Type
hi! link manReference Identifier
hi! link manFooter Title
hi! link manOptionDesc Normal
hi! link manLongOptionDesc Normal

# markdown:
hi! link markdownCode String
hi! link markdownCodeBlock String
hi! link markdownHeadingRule Title
hi! link markdownListMarker Title
hi! link markdownURL Special

# netrw:
hi! link netrwExe String
hi! link netrwClassify SpecialKey

# pkgbuild:
hi! link pbMaintainerGroup Comment


# python:
hi! link pythonBuiltin Type

# readline:
hi! link readlineFunction PreProc
hi! link readlineKey String
hi! link readlineKeyName String
hi! link readlineKeySeparator String
hi! link readlineVariable Type

# rst:
hi! link rstEmphasis htmlBold

# sh:
hi! link shFunctionOne Statement
hi! link shRange Delimiter
hi! link shQuote Delimiter
hi! link shVariable Type
hi! link shSetList Type
hi! link shDerefSimple Type
hi! link shOperator PreProc
hi! link shTestOpr PreProc
hi! link shFor Type
hi! link shVarAssign PreProc
hi! link shVar Constant
hi! link shCaseLabel String
hi! link shCmdParenRegion Type
hi! link shDerefVar Type
hi! link shDeref Type
hi! link shDerefVarArray Type
hi! link shDerefPattern PreProc

# srt:
hi! link srtItalics Italic

# toml:
hi! link tomlBoolean PreProc
hi! link tomlKey Type
hi! link tomlTable Statement

# vim:
hi! link vimHiAttrib String
hi! link vimHiKeyList PreProc
hi! link vimHiBang PreProc
hi! link vimVar Type
hi! link vimIsCommand Type
hi! link vimFunction Identifier
hi! link vimOperParen Type
hi! link vimMapRhs String
hi! link vimMapLhs Constant
hi! link vimUserFunc Identifier
hi! link vimSetEqual String
hi! link vimUserCmd Delimiter
hi! link vimHiBang Statement

# lsp:
hi! link LspDiagSignWarningText WarningMsg
hi! link LspDiagSignInfoText Title

# yaml:
hi! link yamlBlockMappingKey Type
hi! link yamlBool PreProc
hi! link yamlKeyValueDelimiter Delimiter
hi! link yamlNull Special
hi! link yamlPlainScalar String
