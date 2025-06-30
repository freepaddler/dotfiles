" vim-plug
" https://github.com/junegunn/vim-plug
let g:plug_home = expand('~/.config/vim/plugged')

silent! call plug#begin()

" clipboard (OSC 52)
Plug 'ojroques/vim-oscyank', {'branch': 'main'}
let g:oscyank_term = 'default'

" syntax check
Plug 'dense-analysis/ale'
nnoremap <leader>[ :ALEPreviousWrap<CR>
nnoremap <leader>] :ALENextWrap<CR>

" lightline status bar
Plug 'itchyny/lightline.vim'

" nord colorscheme
Plug 'arcticicestudio/nord-vim'

" spaces in the end of lines
Plug 'csexton/trailertrash.vim'
autocmd BufReadPost * let g:show_trailertrash=0

call plug#end()

