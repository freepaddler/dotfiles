" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200
set pastetoggle=<C-p>

" fix occasion press
cmap W w

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

" enchancements
if has('eval')
    let mapleader = "\<SPACE>"

    " Leader mappings for line navigation
    " e: line end, a: first char, b: beginning
    nnoremap <Leader>e $
    nnoremap <Leader>a ^
    nnoremap <Leader>A 0
    vnoremap <Leader>e $
    vnoremap <Leader>a ^
    vnoremap <Leader>A 0

    nnoremap <leader>h :nohlsearch<CR>
    nnoremap <leader>m :call ToggleMouse()<CR>
    nnoremap <leader>n :call ToggleLineNumberMode()<CR>

    " tabs
    " open
    "nnoremap <leader><TAB><TAB> :tabnew<CR>
    nnoremap <leader><TAB>c :tabnew<CR>
    nnoremap <leader><TAB>e :tabnew<CR>:edit 
    nnoremap <leader><TAB>E :tabnew<CR>:Explore<CR>
    " track the last active
    let g:lasttab = 1
    autocmd TabLeave * let g:lasttab = tabpagenr()
    nnoremap <silent> <Leader><TAB><TAB> :execute 'tabn' g:lasttab<CR>
    " navigate
    nnoremap <leader><TAB>n :tabnext<CR>
    nnoremap <leader><TAB>p :tabprevious<CR>
    nnoremap <leader><TAB>l :tablast<CR>
    nnoremap <leader><TAB>f :tabfirst<CR>
    "" close
    nnoremap <leader><TAB>o :tabonly<CR>
    nnoremap <leader><TAB>q :bdelete<CR>

    " buffers
    nnoremap <leader>B <C-^>
    nnoremap <leader>b :ls<CR>:b

    " split
    nnoremap <leader>- :split<CR>
    nnoremap <leader>\ :vsplit<CR>

    " edit or explorer
    nnoremap <leader>E :Explore<CR>
    nnoremap <leader>e :edit 

    " copy to terminal clipboard
    nmap <leader>c <Plug>OSCYankOperator
    nmap <leader>cc <leader>c_
    vmap <leader>c <Plug>OSCYankVisual

    " save file with sudo instead of reopening
    cmap w!! WForce
    cmap WQ! WForceQuit
    "command! WForce :execute ':silent w !$(which sudo || which doas) tee % > /dev/null' | exec "wundo ".escape(undofile(expand('%')),'% ') | :edit!
    command! WForce execute ':silent w !$(command -v sudo || command -v doas) tee % > /dev/null' | execute 'wundo ' . fnameescape(undofile(expand('%'))) | edit!
    command! WForceQuit :execute 'WForce' | :quit!

    " cursor keys
    nnoremap <Up>    :echo "Use k"<CR>
    nnoremap <Down>  :echo "Use j"<CR>
    nnoremap <Left>  :echo "Use h"<CR>
    nnoremap <Right> :echo "Use l"<CR>

    nnoremap <Up>    :echo "Use k"<CR>
    nnoremap <Down>  :echo "Use j"<CR>
    nnoremap <Left>  :echo "Use h"<CR>
    nnoremap <Right> :echo "Use l"<CR>

    inoremap <Up>    <Esc>:echo "Use k"<CR>
    inoremap <Down>  <Esc>:echo "Use j"<CR>
    inoremap <Left>  <Esc>:echo "Use h"<CR>
    inoremap <Right> <Esc>:echo "Use l"<CR>
endif

