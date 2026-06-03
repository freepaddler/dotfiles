vim.g.mapleader = ' '

local map = vim.keymap.set

map('n', '<leader>e', vim.cmd.Ex, { desc = 'Explorer' })

vim.cmd([[
  cnoreabbrev <expr> vx getcmdtype() == ':' && getcmdline() ==# 'vx' ? 'Vexplore' : 'vx'
  cnoreabbrev <expr> hx getcmdtype() == ':' && getcmdline() ==# 'hx' ? 'Hexplore' : 'hx'
  cnoreabbrev <expr> vs getcmdtype() == ':' && getcmdline() ==# 'vs' ? 'vsplit' : 'vs'
  cnoreabbrev <expr> hs getcmdtype() == ':' && getcmdline() ==# 'hs' ? 'split' : 'hs'
]])

-- yank/delete/change
map({ 'n', 'v' }, '<leader>y', [["+y]], { desc = 'Yank to clipboard' })
map('n', '<leader>Y', [["+Y]], { desc = 'Yank until EOF to clibpoard' })

map({ 'n', 'v' }, '<leader>p', [["+p]], { desc = 'Paste after from clipboard' })
map('n', '<leader>P', [["+P]], { desc = 'Paste before from clipboard' })
map('x', '<leader>p', [["_dP]], { desc = 'Replace without yanking' })

map({ 'n', 'v' }, '<leader>d', [["_d]], { desc = 'Delete without yanking' })
map('n', '<leader>D', [["_D]], { desc = 'Delete until EOL without yanking' })

map({ 'n', 'v' }, '<leader>c', [["_c]], { desc = 'Change without yanking' })
map('n', '<leader>C', [["_C]], { desc = 'Change until EOL without yanking' })

-- leave insert mode
map('i', '<C-c>', '<Esc>')
map('i', 'jj', '<Esc>')
map('i', 'jk', '<Esc>')

-- wrapped line movement
map({ 'n', 'v' }, 'j', 'gj')
map({ 'n', 'v' }, 'k', 'gk')

-- Ctrl/Alt-hjkl navigates nvim windows, falling through to tmux panes at the edge.
local function navigate_window_or_tmux(vim_direction, tmux_direction)
    local before = vim.api.nvim_get_current_win()
    vim.cmd('wincmd ' .. vim_direction)

    if before == vim.api.nvim_get_current_win() and vim.env.TMUX then
        vim.system({ 'tmux', 'select-pane', '-' .. tmux_direction }, { detach = true })
    end
end

local function leave_insert_then_navigate(vim_direction, tmux_direction)
    vim.cmd('stopinsert')
    navigate_window_or_tmux(vim_direction, tmux_direction)
end

map('n', '<C-h>', function() navigate_window_or_tmux('h', 'L') end, { desc = 'Navigate left' })
map('n', '<C-j>', function() navigate_window_or_tmux('j', 'D') end, { desc = 'Navigate down' })
map('n', '<C-k>', function() navigate_window_or_tmux('k', 'U') end, { desc = 'Navigate up' })
map('n', '<C-l>', function() navigate_window_or_tmux('l', 'R') end, { desc = 'Navigate right' })

map({ 'n', 'x' }, '<M-h>', function() navigate_window_or_tmux('h', 'L') end, { desc = 'Navigate left' })
map({ 'n', 'x' }, '<M-j>', function() navigate_window_or_tmux('j', 'D') end, { desc = 'Navigate down' })
map({ 'n', 'x' }, '<M-k>', function() navigate_window_or_tmux('k', 'U') end, { desc = 'Navigate up' })
map({ 'n', 'x' }, '<M-l>', function() navigate_window_or_tmux('l', 'R') end, { desc = 'Navigate right' })
map('i', '<M-h>', function() leave_insert_then_navigate('h', 'L') end, { desc = 'Navigate left' })
map('i', '<M-j>', function() leave_insert_then_navigate('j', 'D') end, { desc = 'Navigate down' })
map('i', '<M-k>', function() leave_insert_then_navigate('k', 'U') end, { desc = 'Navigate up' })
map('i', '<M-l>', function() leave_insert_then_navigate('l', 'R') end, { desc = 'Navigate right' })

-- scroll/search screen with centeringj
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')
map('n', '<leader>n', '<cmd>nohlsearch<CR>', { desc = 'Disable search highlight' })

-- move selected block
map('v', 'J', [[:m '>+1<CR>gv=gv]], { desc = 'Move selection line down' })
map('v', 'K', [[:m '<-2<CR>gv=gv]], { desc = 'Move selection line up' })
map('n', 'J', 'mzJ`z', { desc = 'Join line and keep cursor position' })

-- buffers
map('n', '<leader>bn', ':bnext<CR>', { desc = 'Buffer: next' })
map('n', '<leader>bp', ':bprevious<CR>', { desc = 'Buffer: previous' })
map('n', '<leader>bl', '<C-^>', { desc = 'Buffer: last' })

-- tabs
map('n', '<leader><TAB>c', '<cmd>tabnew<CR>', { desc = 'Create tab' })
map('n', '<leader><TAB>e', '<cmd>tabnew<CR><cmd>Ex<CR>', { desc = 'New tab Ex' })
map('n', '<leader><TAB>gf', '<C-w>gf', { desc = 'GoTo file in new tab' })
map('n', '<leader><TAB>n', 'gt', { desc = 'Next tab' })
map('n', '<leader><TAB>p', 'gT', { desc = 'Prevous tab' })
-- track last active tab
vim.g.lasttab = 1
vim.api.nvim_create_autocmd('TabLeave', {
    callback = function()
        vim.g.lasttab = vim.fn.tabpagenr()
    end,
})
map('n', '<leader><Tab><Tab>', function()
    vim.cmd('tabn ' .. vim.g.lasttab)
end, { desc = 'Last tab' })
map('n', '<leader><TAB>1', '1gt', { desc = 'Goto tab 1' })
map('n', '<leader><TAB>2', '2gt', { desc = 'Goto tab 2' })
map('n', '<leader><TAB>3', '3gt', { desc = 'Goto tab 3' })
map('n', '<leader><TAB>4', '4gt', { desc = 'Goto tab 4' })
map('n', '<leader><TAB>5', '5gt', { desc = 'Goto tab 5' })
map('n', '<leader><TAB>6', '6gt', { desc = 'Goto tab 6' })
map('n', '<leader><TAB>7', '7gt', { desc = 'Goto tab 7' })
map('n', '<leader><TAB>8', '8gt', { desc = 'Goto tab 8' })
map('n', '<leader><TAB>9', '9gt', { desc = 'Goto tab 9' })

-- tmux-sessionizer
map('n', '<M-f>', function()
    if vim.env.TMUX == nil then
        return
    end
    vim.cmd('silent !tmux display-popup -E tmux-sessionizer')
end, { noremap = true, silent = true, desc = 'tmux-sessionizer' })

-- queickfix entry
map('n', '<leader>[p', '<cmd>copen<CR>', { desc = 'Quickfix open' })
map('n', '<leader>]p', '<cmd>cclose<CR>', { desc = 'Quickfix close' })
map('n', ']p', '<cmd>cnext<CR>zz', { desc = 'Quickfix next' })
map('n', '[p', '<cmd>cprev<CR>zz', { desc = 'Quickfix prev' })
-- location list entry
map('n', '<leader>[l', '<cmd>lopen<CR>', { desc = 'Location open' })
map('n', '<leader>]l', '<cmd>lclose<CR>', { desc = 'Location close' })
map('n', ']l', '<cmd>lnext<CR>zz', { desc = 'Location next' })
map('n', '[l', '<cmd>lprev<CR>zz', { desc = 'Location prev' })
-- diagnostics entry
map('n', '<leader>[d', function()
    vim.diagnostic.setloclist()
    vim.cmd('lopen')
end, { desc = 'Diagnostics → location list (open)' })
map('n', ']d', function()
    vim.diagnostic.goto_next()
    vim.cmd('normal! zz')
end, { desc = 'Diagnostics next' })
map('n', '[d', function()
    vim.diagnostic.goto_prev()
    vim.cmd('normal! zz')
end, { desc = 'Diagnostics prev' })

-- save file with sudo instead of reopening
vim.cmd([[
  command! WForce execute ':silent w !$(command -v sudo || command -v doas) tee % > /dev/null' |
        \ execute 'wundo ' . fnameescape(undofile(expand('%'))) |
        \ edit!

  command! WForceQuit execute 'WForce' | quit!

  cmap w!! WForce
  cmap WQ! WForceQuit
]])

-- single W = w
vim.cmd([[
  cnoreabbrev <expr> W getcmdtype() == ':' && getcmdline() ==# 'W' ? 'w' : 'W'
]])

-- misc
map('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Replace word under cursor' })
map('n', '<leader>X', '<cmd>!chmod +x %<CR>', { desc = 'Make file executable', silent = true })

-- block cursor keys for navigation, but keep them available in insert-mode prompts
map({ 'n', 'v' }, '<Up>', [[<cmd>echo 'Use k'<CR>]])
map({ 'n', 'v' }, '<Down>', [[<cmd>echo 'Use j'<CR>]])
map({ 'n', 'v' }, '<Left>', [[<cmd>echo 'Use h'<CR>]])
map({ 'n', 'v' }, '<Right>', [[<cmd>echo 'Use l'<CR>]])
