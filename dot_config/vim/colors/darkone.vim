" darkone.vim — 256-color terminal-safe theme OneDark base
" based on OneDark colors https://github.com/one-dark
"
" Terminal color reference:
"   normal name     hex       → xterm color   index
"   -----------------------------------------------
"   color0   black           #4b5263 → #44475a   238
"   color1   red             #e06c75 → #d75f5f   167
"   color2   green           #98c379 → #87af5f   107
"   color3   yellow          #e5c07b → #d7af5f   179
"   color4   blue            #61afef → #5f87ff    68
"   color5   magenta         #c678dd → #af5faf   133
"   color6   cyan            #56b6c2 → #5fafd7    73
"   color7   white           #c0c5ce → #d0d0d0   252
"
"   bright name     hex       → xterm color   index
"   -----------------------------------------------
"   color8   brightblack     #5c6370 → #585858   240
"   color9   brightred       #ef8f94 → #d78787   174
"   color10  brightgreen     #a5e075 → #afdf87   149
"   color11  brightyellow    #f0c97b → #ffd787   221
"   color12  brightblue      #82b8ff → #87b7ff   117
"   color13  brightmagenta   #d19aff → #d7afff   183
"   color14  brightcyan      #88cddf → #87d7df   152
"   color15  brightwhite     #ffffff → #ffffff   231

set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "darkone"

" UI
hi Normal           ctermfg=252     ctermbg=NONE
hi Cursor           ctermfg=231     ctermbg=240
hi Visual                           ctermbg=252
hi LineNr           ctermfg=252
hi CursorLineNr     ctermfg=231     ctermbg=NONE    cterm=bold
hi CursorLine                       ctermbg=238     cterm=bold
hi StatusLine       ctermfg=252     ctermbg=NONE
hi StatusLineNC     ctermfg=240     ctermbg=238
hi VertSplit        ctermfg=240     ctermbg=238
hi Pmenu            ctermfg=252     ctermbg=238
hi PmenuSel         ctermfg=238     ctermbg=68
hi Search           ctermfg=238     ctermbg=117
hi IncSearch        ctermfg=240     ctermbg=221     cterm=underline,bold
hi MatchParen       ctermfg=240     ctermbg=68
hi ColorColumn                      ctermbg=240

" Syntax (ctermfg only, no background override)
hi Comment          ctermfg=240
hi Constant         ctermfg=73
hi String           ctermfg=107
hi Character        ctermfg=107
hi Number           ctermfg=179
hi Boolean          ctermfg=179
hi Float            ctermfg=179

hi Identifier       ctermfg=68
hi Function         ctermfg=68

hi Statement        ctermfg=133
hi Conditional      ctermfg=133
hi Repeat           ctermfg=133
hi Label            ctermfg=133
hi Operator         ctermfg=252
hi Keyword          ctermfg=133
hi Exception        ctermfg=133

hi PreProc          ctermfg=179
hi Include          ctermfg=179
hi Define           ctermfg=179
hi Macro            ctermfg=179
hi PreCondit        ctermfg=179

hi Type             ctermfg=133
hi StorageClass     ctermfg=133
hi Structure        ctermfg=133
hi Typedef          ctermfg=133

hi Special          ctermfg=73
hi SpecialChar      ctermfg=73
hi Tag              ctermfg=73
hi Delimiter        ctermfg=252
hi SpecialComment   ctermfg=240
hi Debug            ctermfg=167

hi Underlined       ctermfg=68                      cterm=underline
hi Ignore           ctermfg=240
hi Error            ctermfg=231     ctermbg=167
hi Todo             ctermfg=179     ctermbg=238     cterm=bold

" Diffs
hi DiffAdd          ctermfg=107     ctermbg=NONE
hi DiffChange       ctermfg=68      ctermbg=NONE
hi DiffDelete       ctermfg=167     ctermbg=NONE
hi DiffText         ctermfg=73      ctermbg=NONE
