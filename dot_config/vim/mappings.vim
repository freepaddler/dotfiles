" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

let mapleader = "\<SPACE>"

" copy to terminal clipboard
nmap <leader>c <Plug>OSCYankOperator
nmap <leader>cc <leader>c_
vmap <leader>c <Plug>OSCYankVisual

nnoremap <leader>h :nohlsearch<CR>
nnoremap <leader>m :call ToggleMouse()<CR>
nnoremap <leader>n :call ToggleLineNumberMode()<CR>
nnoremap <Leader>p :set invpaste<CR>

" split
nnoremap <leader>- :split<CR>:Explore<CR>
nnoremap <leader>\ :vsplit<CR>:Explore<CR>

" fix occasion press
cmap W w

" save file with sudo instead of reopening
cmap w!! WForce
cmap WQ! WForceQuit
command! WForce :execute ':silent w !$(which sudo || which doas) tee % > /dev/null' | exec "wundo ".escape(undofile(expand('%')),'% ') | :edit!
command! WForceQuit :execute 'WForce' | :quit!

" motion
" wrapped line movement
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
" simple leave INSERT mode
inoremap jj <Esc>
inoremap jk <Esc>
" Ctrl+ to move between windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" cursor keys
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" Leader mappings for line navigation
" e: line end, a: first char, b: beginning
nnoremap <Leader>e $ 
nnoremap <Leader>a ^
nnoremap <Leader>b 0
vnoremap <Leader>e $
vnoremap <Leader>a ^
vnoremap <Leader>b 0

" jump to paired bracket
nnoremap \| %

