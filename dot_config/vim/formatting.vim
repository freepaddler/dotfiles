syntax on                   
set wrap

" tabs and alignment
set tabstop=4               " \t spaces (view mode)
set softtabstop=4           " \t spaces (edit mode)
set shiftwidth=4            " ident with << >>
set smarttab                " adjusts ts to sts
set expandtab               " spaces instead of \t

" indents
set autoindent              " save ident for new lines
set cin                     " C-style ident 
set smartindent             " indent for code blocks
set pastetoggle=<C-p>       " disable indent on paste

" other
set backspace=indent,eol,start      " backspace everywhere
set nostartofline           " save col when change line
set scrolloff=4             " leave lines on screen top/bottom

" file types
autocmd Filetype yaml setlocal et ts=2 sts=2 sw=2
autocmd Filetype json setlocal et ts=2 sts=2 sw=2
autocmd Filetype make setlocal noet
autocmd Filetype go   setlocal noet 
