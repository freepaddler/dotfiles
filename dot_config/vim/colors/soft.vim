" soft.vim for 16-color terminals 
set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "soft"

" UI
hi Normal        ctermfg=7  ctermbg=NONE
hi Cursor        ctermfg=15 ctermbg=8
hi Visual                   ctermbg=7
hi LineNr        ctermfg=0
hi CursorLineNr  ctermfg=15 ctermbg=NONE cterm=bold
hi CursorLine               ctermbg=0 cterm=bold
hi StatusLine    ctermfg=7  ctermbg=NONE
hi StatusLineNC  ctermfg=8  ctermbg=0
hi VertSplit     ctermfg=8  ctermbg=0
hi Pmenu         ctermfg=7  ctermbg=0
hi PmenuSel      ctermfg=0  ctermbg=4
hi Search        ctermfg=0  ctermbg=12
hi IncSearch     ctermfg=8  ctermbg=11 cterm=underline,bold
hi MatchParen    ctermfg=8  ctermbg=4
hi ColorColumn              ctermbg=8

" Syntax (ctermfg only, no background override)
hi Comment       ctermfg=8 
hi Constant      ctermfg=6
hi String        ctermfg=2
hi Character     ctermfg=2
hi Number        ctermfg=3
hi Boolean       ctermfg=3
hi Float         ctermfg=3

hi Identifier    ctermfg=4
hi Function      ctermfg=4

hi Statement     ctermfg=5
hi Conditional   ctermfg=5
hi Repeat        ctermfg=5
hi Label         ctermfg=5
hi Operator      ctermfg=7
hi Keyword       ctermfg=5
hi Exception     ctermfg=5

hi PreProc       ctermfg=3
hi Include       ctermfg=3
hi Define        ctermfg=3
hi Macro         ctermfg=3
hi PreCondit     ctermfg=3

hi Type          ctermfg=5
hi StorageClass  ctermfg=5
hi Structure     ctermfg=5
hi Typedef       ctermfg=5

hi Special       ctermfg=6
hi SpecialChar   ctermfg=6
hi Tag           ctermfg=6
hi Delimiter     ctermfg=7
hi SpecialComment ctermfg=8
hi Debug         ctermfg=1

hi Underlined    ctermfg=4 cterm=underline
hi Ignore        ctermfg=8
hi Error         ctermfg=15 ctermbg=1
hi Todo          ctermfg=3  ctermbg=0 cterm=bold

" Diffs
hi DiffAdd       ctermfg=2 ctermbg=NONE
hi DiffChange    ctermfg=4 ctermbg=NONE
hi DiffDelete    ctermfg=1 ctermbg=NONE
hi DiffText      ctermfg=6 ctermbg=NONE
