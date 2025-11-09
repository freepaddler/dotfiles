" vim-plugi
" https://github.com/junegunn/vim-plug
let g:plug_home = expand('$XDG_CONFIG_HOME/vim/plugged')

silent! call plug#begin()

" clipboard (OSC 52)
Plug 'ojroques/vim-oscyank', {'branch': 'main'}
let g:oscyank_term = 'default'

" syntax check
Plug 'dense-analysis/ale'
nmap [e <Plug>(ale_previous_wrap)
nmap ]e <Plug>(ale_next_wrap)

" lightline status bar
Plug 'itchyny/lightline.vim'

" nord colorscheme
Plug 'arcticicestudio/nord-vim'

" trim spaces at the end of lines
Plug 'csexton/trailertrash.vim'
"autocmd VimEnter * let g:show_trailertrash=0

call plug#end()

