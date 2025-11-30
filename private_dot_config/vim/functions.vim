" truncates path if it does not fit statusline
" wraps current dir in []
function! TruncateFullPath()
  let l:fullpath = expand('%:p')
  let l:cwd = getcwd()
  let l:filename = expand('%:t')

  " replace $HOME with ~
  let l:home = expand('$HOME')
  if l:fullpath[:strlen(l:home)-1] ==# l:home
    let l:fullpath = '~' . l:fullpath[strlen(l:home):]
    let l:cwd = substitute(l:cwd, '^' . l:home, '~', '')
  endif

  " wrap cwd in []
   if l:fullpath[:strlen(l:cwd)-1] ==# l:cwd
    let l:fullpath = '[' . l:cwd . ']/' . l:fullpath[strlen(l:cwd) + 1:]
  endif

  let l:avail = winwidth(0) - 72

  " filename only if no space available
  if l:avail <= strlen(l:filename)
    return l:filename
  endif

  " fullpath if fits
  if strlen(l:fullpath) <= l:avail
    return l:fullpath
  endif

  " fullpath truncate
  return '…' . strpart(l:fullpath, strlen(l:fullpath) - l:avail)
endfunction

" Capture the time the file was saved
autocmd BufWritePost * let b:file_saved_time = localtime()
" Shows related time after file was saved
function! RelativeModifiedTime()
    " Get the current time in seconds
    let l:now = localtime()

    if exists('b:file_saved_time')
        let l:time = b:file_saved_time
    else
        return '' " If no times are available, return empty
    endif

    " Calculate the time difference
    let l:diff = l:now - l:time

    " Break the difference into hours, minutes, and seconds
    let l:h = l:diff / 3600
    let l:m = (l:diff % 3600) / 60
    let l:s = l:diff % 60

    " Format the result like 1h2m3s, skip zero values
    let l:result = (l:h > 0 ? l:h . 'h' : '') .
                  \ (l:m > 0 ? l:m . 'm' : '') .
                  \ (l:s > 0 ? l:s . 's' : '') .
                  \ (l:diff > 0 ? ' ago ' : '')

    return l:result
endfunction

" switch line numbers show mode: absolute-hidden-relative
function! ToggleLineNumberMode()
    if &number && &relativenumber
        set norelativenumber
    elseif &number
        set nonumber
    else
        set number
        set relativenumber
    endif
endfunction


function! ToggleMouse()
    if !has('mouse')
        echo "Mouse support is not available."
        return
    endif
    if g:mouse_enabled
        let g:mouse_enabled = 0
        set mouse=
        echo "Mouse disabled"
    else
        let g:mouse_enabled = 1
        set mouse=a
        echo "Mouse enabled"
    endif
endfunction

function! RemoteHost()
  if !empty($SSH_CONNECTION)
    return hostname()->split('\.')[0]
  endif
  return ''
endfunction
