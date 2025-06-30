set termguicolors

colorscheme nord

set cursorline          " higlight current line
set number              " line numbering
set relativenumber
hi LineNr ctermfg=black
set colorcolumn=81      " higlight column 81
hi ColorColumn ctermbg=black  

" show extra whitespaces asdqw qweqwe wq
"hi ExtraWhitespace ctermfg=cyan cterm=underline
"autocmd ColorScheme * hi ExtraWhitespace ctermfg=cyan cterm=underline
"match ExtraWhitespace /\s\+$/
"autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
"autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
"autocmd InsertLeave * match ExtraWhitespace /\s\+$/
"autocmd BufWinLeave * call clearmatches()

" statusline
set laststatus=2        " statusline show always
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' },
      \ 'component_function': {
      \     'relmod': 'RelativeModifiedTime',
      \     'fullpathtrunc': 'TruncateFullPath'
      \ },
      \ 'active': {
      \     'left': [ [ 'mode', 'paste' ],
      \               [ 'readonly', 'fullpathtrunc', 'modified', 'relmod' ] ]
      \ }
      \ }


" mouse
if has('mouse')
    set ttymouse=sgr
    set mouse=a
    let g:mouse_enabled = 1
endif

" reload
set lz                  " lazy redraw
set autoread            " reload if changed out of vim, and no local changes
au CursorHold,CursorHoldI * checktime " reload on cursor hold/invoke default 4s

" command mode
set wildmenu            " visual autocomplete for command menu
set showcmd             " display incomplete commands

" split
set splitright          " vsplit always right
set splitbelow          " split always down

" search
set showmatch           " brackets
set hlsearch            " last search
set incsearch           " incremental
set ignorecase          " case insensitive
set smartcase           " case sensitive if uppercase input

" fallback
"colorscheme desertold
"highlight MatchParen cterm=bold ctermbg=blue ctermfg=white
"highlight Visual ctermbg=grey
"hi CursorLine cterm=bold ctermbg=NONE
"hi CursorLineNr cterm=bold ctermbg=NONE ctermfg=grey
"" user colors
"hi User1 ctermfg=green
"hi User2 ctermfg=white
"hi User3 ctermfg=cyan
"hi User4 ctermfg=red
"hi User5 ctermfg=grey
"" statusline
"set statusline=
"set statusline+=%1*%F               "filename with path
"set statusline+=\
"set statusline+=%5*%y               "file syntax
"set statusline+=\
"set statusline+=%=                  "left/right separator
"set statusline+=%5*%{RelativeModifiedTime()}
"set statusline+=%4*%m               "modified
"set statusline+=%3*%r               "read only
"set statusline+=%2*
"set statusline+=\ %11(%c,%l/%L%)    "current col,line/total
"set statusline+=\ %P                "percent through file
