" core runtime data

" viminfo, backup, swap and undo settings
silent !mkdir -m 4700 -p ~/.local/vim/swap ~/.local/vim/backup ~/.local/vim/undo

set directory=~/.local/vim/swap
set viminfo+=n~/.local/vim/viminfo
" set backupdir=~/.local/vim/backup
set undofile
set undodir=~/.local/vim/undo
if has("eval")
    " delete undo history after 365 days
    let s:undos = split(globpath(&undodir, '*'), "\n")
    call filter(s:undos, 'getftime(v:val) < localtime() - (60 * 60 * 24 * 365)')
    call map(s:undos, 'delete(v:val)')
endif

" don't write .netrwhist
let g:netrw_dirhistmax = 0

" read .vimrc also from local dirs
set exrc
set secure
set modelines=5         " read vim settings from file itself

" file formats and encoding order
set encoding=utf-8
set ffs=unix,mac,dos
set fencs=utf-8,cp1251,koi8-r,cp866

set hidden              " allow switch buffer without save

" other
" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup nobackup
au BufWrite /tmp/crontab.* set nowritebackup nobackup
" Don't write backup file if vim is being called by "chpass" or "vipw"
au BufWrite /private/etc/pw.* set nowritebackup nobackup
au BufWrite /etc/pw.* set nowritebackup nobackup
