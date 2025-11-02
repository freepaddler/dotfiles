" core runtime data

" viminfo and undo location
silent !mkdir -p -m 4700 $XDG_DATA_HOME/vim/undo

if has('viminfofile')
  set viminfofile=$XDG_DATA_HOME/vim/viminfo
else
  set viminfo+=n$XDG_DATA_HOME/vim/viminfo
endif
set noswapfile
set nobackup
set undodir=$XDG_DATA_HOME/vim/undo
set undofile

if has("eval")
    " delete undo history after 365 days
    let s:undos = split(globpath(&undodir, '*'), "\n")
    call filter(s:undos, 'getftime(v:val) < localtime() - (60 * 60 * 24 * 365)')
    call map(s:undos, 'delete(v:val)')

    " don't write .netrwhist
    let g:netrw_dirhistmax = 0
    let g:netrw_browse_split = 0
    let g:netrw_banner = 0
    let g:netrw_winsize = 25
endif

" read .vimrc also from local dirs
set exrc
set secure
set modelines=5         " read vim settings from file itself

" file formats and encoding order
set encoding=utf-8
set ffs=unix,mac,dos
set fencs=utf-8,cp1251,koi8-r,cp866

set hidden              " allow switch buffer without save
set isfname+=@-@        " treat @ as filename
