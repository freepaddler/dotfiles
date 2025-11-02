" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200
inoremap <C-c> <Esc>
nnoremap Q <nop>

" paste with/without idents
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
" line navigation
nnoremap <C-a> ^
nnoremap <C-e> $
"Ctrl+ to move between windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" join line leave coursour untouched
nnoremap J mzJ`z
" scroll screen with centeringj
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
" search with centering
nnoremap n nzzzv
nnoremap N Nzzzv
" move selected block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
" buffers navigation
nnoremap <C-S-j> :bnext<CR>
nnoremap <C-S-k> :bprev<CR>

" enchancements
if has('eval')
    let mapleader = "\<SPACE>"

    " paste over saving current buffer
    xnoremap <leader>p "_dP
    " delete to black-hole buffer
    nnoremap <leader>d "_d
    vnoremap <leader>d "_d
    " replace word globally
    nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

    nnoremap <silent> <leader>x :!chmod +x %<CR>

    nnoremap <leader>h :nohlsearch<CR>
    nnoremap <leader>m :call ToggleMouse()<CR>
    nnoremap <leader>n :call ToggleLineNumberMode()<CR>

    " close buffer and quit on last
    nnoremap <silent> <leader>q :if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1 \| confirm bdelete \| else \| confirm quit \| endif<CR>

    " tabs
    " open
    nnoremap <leader><TAB>c :tabnew<CR>
    nnoremap <leader><TAB>e :tabnew<CR>:edit 
    nnoremap <leader><TAB>E :tabnew<CR>:Explore<CR>
    nnoremap <leader><TAB>gf <C-w>gf
    " navigate
    nnoremap <leader><TAB>n :tabnext<CR>
    nnoremap <leader><TAB>p :tabprevious<CR>
    nnoremap <leader><TAB>l :tablast<CR>
    nnoremap <leader><TAB>f :tabfirst<CR>
    nnoremap <leader><TAB>o :tabonly<CR>
    " track the last active
    let g:lasttab = 1
    autocmd TabLeave * let g:lasttab = tabpagenr()
    nnoremap <silent> <Leader><TAB><TAB> :execute 'tabn' g:lasttab<CR>

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

endif

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
