" deafaults (no colorsheme)
hi LineNr ctermfg=darkgray

" colorscheme
if has('termguicolors')
    set termguicolors
    colorscheme nord
    hi LineNr ctermfg=black
    hi ColorColumn ctermbg=black
endif

set cursorline          " higlight current line
set number              " line numbering
set relativenumber      " relative numbers
set colorcolumn=81      " higlight column 81
set signcolumn=yes      " always who sign column

" statusline
if has('statusline')
    set laststatus=2        " statusline show always
    "let g:lightline = {
    "      \ 'colorscheme': 'nord',
    "      \ 'separator': { 'left': '', 'right': '' },
    "      \ 'subseparator': { 'left': '', 'right': '' },
    "      \ 'component_function': {
    "      \     'relmod': 'RelativeModifiedTime',
    "      \     'fullpathtrunc': 'TruncateFullPath',
    "      \     'remotehost': 'RemoteHost'
    "      \ },
    "      \ 'active': {
    "      \     'left': [ [ 'mode', 'paste' ], [ 'remotehost' ],
    "      \               [ 'readonly', 'fullpathtrunc', 'modified', 'relmod' ] ]
    "
    "      \ }
    "      \ }
    set noshowmode
    let g:lightline = {
          \ 'colorscheme': 'nord',
          \ 'component_function': {
          \     'relmod': 'RelativeModifiedTime',
          \     'fullpathtrunc': 'TruncateFullPath',
          \     'remotehost': 'RemoteHost'
          \ },
          \ 'active': {
          \     'left': [ [ 'mode', 'paste' ], [ 'remotehost' ],
          \               [ 'readonly', 'fullpathtrunc', 'modified', 'relmod' ] ]
          \ }
          \ }
endif

" mouse
if has('mouse')
    set ttymouse=sgr
    set mouse=
    if has('eval')
        let g:mouse_enabled = 0
    endif
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
set hlsearch            " last search
set incsearch           " incremental
set ignorecase          " case insensitive
set smartcase           " case sensitive if uppercase input
