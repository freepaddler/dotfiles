" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=100

let mapleader = "\<Space>"
let maplocalleader = "\\"

nnoremap Q <nop>
inoremap <C-c> <Esc>
inoremap jj <Esc>
inoremap jk <Esc>

" General
nnoremap <C-s> :write<CR>
nnoremap <leader>- :split<CR>
nnoremap <leader>\ :vsplit<CR>

" Movement and editing
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Block cursor keys for navigation, but keep them available in insert-mode prompts
nnoremap <Up> :echo "Use k"<CR>
nnoremap <Down> :echo "Use j"<CR>
nnoremap <Left> :echo "Use h"<CR>
nnoremap <Right> :echo "Use l"<CR>
vnoremap <Up> :echo "Use k"<CR>
vnoremap <Down> :echo "Use j"<CR>
vnoremap <Left> :echo "Use h"<CR>
vnoremap <Right> :echo "Use l"<CR>

if has('eval')
    function! s:NavigateWindowOrTmux(vim_direction, tmux_direction) abort
        let l:before = winnr()
        execute 'wincmd ' . a:vim_direction

        if l:before == winnr() && !empty($TMUX) && executable('tmux')
            call system(['tmux', 'select-pane', '-' . a:tmux_direction])
        endif
    endfunction

    function! s:CurrentFileDir() abort
        let l:path = expand('%:p:h')
        return empty(l:path) ? getcwd() : l:path
    endfunction

    function! s:Explore(path, new_tab) abort
        if a:new_tab
            tabnew
        endif
        execute 'Explore' fnameescape(a:path)
    endfunction

    function! s:DeleteOtherBuffers() abort
        let l:current = bufnr('%')
        for l:buffer in range(1, bufnr('$'))
            if l:buffer != l:current && buflisted(l:buffer)
                execute 'silent! bdelete' l:buffer
            endif
        endfor
    endfunction

    " Window and tmux pane navigation
    nnoremap <C-h> <C-w>h
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l
    nnoremap <silent> <M-h> :call <SID>NavigateWindowOrTmux('h', 'L')<CR>
    nnoremap <silent> <M-j> :call <SID>NavigateWindowOrTmux('j', 'D')<CR>
    nnoremap <silent> <M-k> :call <SID>NavigateWindowOrTmux('k', 'U')<CR>
    nnoremap <silent> <M-l> :call <SID>NavigateWindowOrTmux('l', 'R')<CR>
    xnoremap <silent> <M-h> :<C-u>call <SID>NavigateWindowOrTmux('h', 'L')<CR>
    xnoremap <silent> <M-j> :<C-u>call <SID>NavigateWindowOrTmux('j', 'D')<CR>
    xnoremap <silent> <M-k> :<C-u>call <SID>NavigateWindowOrTmux('k', 'U')<CR>
    xnoremap <silent> <M-l> :<C-u>call <SID>NavigateWindowOrTmux('l', 'R')<CR>
    inoremap <silent> <M-h> <Esc>:call <SID>NavigateWindowOrTmux('h', 'L')<CR>
    inoremap <silent> <M-j> <Esc>:call <SID>NavigateWindowOrTmux('j', 'D')<CR>
    inoremap <silent> <M-k> <Esc>:call <SID>NavigateWindowOrTmux('k', 'U')<CR>
    inoremap <silent> <M-l> <Esc>:call <SID>NavigateWindowOrTmux('l', 'R')<CR>

    " Clipboard
    nnoremap <leader>y "+y
    vnoremap <leader>y "+y
    nnoremap <leader>Y "+Y
    nnoremap <leader>p "+p
    vnoremap <leader>p "_dP
    nnoremap <leader>P "+P

    " Registers / void
    nnoremap <leader>vd "_d
    vnoremap <leader>vd "_d
    nnoremap <leader>vD "_D
    nnoremap <leader>vc "_c
    vnoremap <leader>vc "_c
    nnoremap <leader>vC "_C
    nnoremap <leader>vy "+y
    vnoremap <leader>vy "+y
    nnoremap <leader>vY "+Y
    nnoremap <leader>vp "+p
    vnoremap <leader>vp "+p
    nnoremap <leader>vP "+P

    " Buffers
    nnoremap [b :bprevious<CR>
    nnoremap ]b :bnext<CR>
    nnoremap <leader>bd :bdelete<CR>
    nnoremap <silent> <leader>bD :call <SID>DeleteOtherBuffers()<CR>
    nnoremap <leader>bn :bnext<CR>
    nnoremap <leader>bp :bprevious<CR>
    nnoremap <leader>bl <C-^>

    " Tabs
    nnoremap [t gT
    nnoremap ]t gt
    nnoremap <leader><Tab>d :tabclose<CR>
    nnoremap <leader><Tab>D :tabonly<CR>
    nnoremap <leader><Tab>c :tabnew<CR>
    nnoremap <silent> <leader><Tab>e :call <SID>Explore(<SID>CurrentFileDir(), 1)<CR>
    nnoremap <silent> <leader><Tab>E :call <SID>Explore(getcwd(), 1)<CR>
    nnoremap <leader><Tab>gf <C-w>gf
    nnoremap <leader><Tab>n gt
    nnoremap <leader><Tab>p gT

    let g:lasttab = 1
    augroup VimLastTab
        autocmd!
        autocmd TabLeave * let g:lasttab = tabpagenr()
    augroup END
    nnoremap <silent> <leader><Tab><Tab> :execute 'tabn' g:lasttab<CR>
    nnoremap <leader><Tab>1 1gt
    nnoremap <leader><Tab>2 2gt
    nnoremap <leader><Tab>3 3gt
    nnoremap <leader><Tab>4 4gt
    nnoremap <leader><Tab>5 5gt
    nnoremap <leader><Tab>6 6gt
    nnoremap <leader><Tab>7 7gt
    nnoremap <leader><Tab>8 8gt
    nnoremap <leader><Tab>9 9gt

    " Explorer
    nnoremap <silent> <leader>ee :call <SID>Explore(<SID>CurrentFileDir(), 0)<CR>
    nnoremap <silent> <leader>eE :call <SID>Explore(getcwd(), 0)<CR>
    cnoreabbrev <expr> vx getcmdtype() == ':' && getcmdline() ==# 'vx' ? 'Vexplore' : 'vx'
    cnoreabbrev <expr> hx getcmdtype() == ':' && getcmdline() ==# 'hx' ? 'Hexplore' : 'hx'
    cnoreabbrev <expr> vs getcmdtype() == ':' && getcmdline() ==# 'vs' ? 'vsplit' : 'vs'
    cnoreabbrev <expr> hs getcmdtype() == ':' && getcmdline() ==# 'hs' ? 'split' : 'hs'

    " Search
    nnoremap <leader>ss :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

    " UI toggles
    nnoremap <leader>uh :set hlsearch!<CR>
    nnoremap <leader>ul :set number!<CR>
    nnoremap <leader>uL :set relativenumber!<CR>
    nnoremap <leader>um :call ToggleMouse()<CR>

    " Code
    nnoremap <silent> <leader>cX :!chmod +x %<CR>

    " Quickfix / location lists
    nnoremap ]q :cnext<CR>zz
    nnoremap [q :cprev<CR>zz
    nnoremap ]l :lnext<CR>zz
    nnoremap [l :lprev<CR>zz

    " Yank also copy to terminal clipboard
    " The + and * registers will not be distinct from the unnamed register. In
    " this case, a:event.regname will always be '' (empty string). However, it
    " can be the case that `has('clipboard_working')` is false, yet `+` is
    " still distinct, so we want to check them all.
    let s:VimOSCYankPostRegisters = ['', '+', '*']
    let s:VimOSCYankOperators = ['y']
    function! s:VimOSCYankPostCallback(event) abort
        if index(s:VimOSCYankPostRegisters, a:event.regname) != -1
                    \ && index(s:VimOSCYankOperators, a:event.operator) != -1
            call OSCYankRegister(a:event.regname)
        endif
    endfunction
    augroup VimOSCYankPost
        autocmd!
        autocmd TextYankPost * call s:VimOSCYankPostCallback(v:event)
    augroup END

    " Save file with sudo instead of reopening
    command! WForce execute ':silent w !$(command -v sudo || command -v doas) tee % > /dev/null' | execute 'wundo ' . fnameescape(undofile(expand('%'))) | edit!
    command! WForceQuit execute 'WForce' | quit!
    cmap w!! WForce
    cmap WQ! WForceQuit

    " Common typo
    cmap W w
endif
