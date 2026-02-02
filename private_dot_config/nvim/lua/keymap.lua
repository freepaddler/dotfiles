vim.g.mapleader = ' '

local map = vim.keymap.set

map('n', '<leader>e', vim.cmd.Ex, { desc = 'Explorer' })
map('n', '<leader>b', '<cmd>ls<CR>:b', { desc = 'Buffers quick actions' })

-- yank/delete/change
map({'n','v'}, '<leader>y', [["+y]], { desc = 'Yank to clipboard' })
map('n', '<leader>Y', [["+Y]], { desc = 'Yank until EOF to clibpoard' })

map({'n','v'}, '<leader>p', [["+p]], { desc = 'Paste after from clipboard' })
map('n', '<leader>P', [["+P]], { desc = 'Paste before from clipboard' })
map('x', '<leader>p', [["_dP]], { desc = 'Replace without yanking' })

map({'n','v'}, '<leader>d', [["_d]], { desc = 'Delete without yanking' })
map('n','<leader>D', [["_D]], { desc = 'Delete until EOL without yanking' })

map({'n','v'}, '<leader>c', [["_c]], { desc = 'Change without yanking' })
map('n', '<leader>C', [["_C]], { desc = 'Change until EOL without yanking' })

-- leave insert mode
map('i', '<C-c>', '<Esc>')
map('i', 'jj', '<Esc>')
map('i', 'jk', '<Esc>')

-- wrapped line movement
map({'n','v'}, 'j', 'gj')
map({'n','v'}, 'k', 'gk')

-- Ctrl-hjkl to move between windows
map('n', '<C-h>', '<C-w>h', { desc = 'Navigate window left' })
map('n', '<C-j>', '<C-w>j', { desc = 'Navigate window down' })
map('n', '<C-k>', '<C-w>k', { desc = 'Navigate window up' })
map('n', '<C-l>', '<C-w>l', { desc = 'Navigate window right' })

-- scroll/search screen with centeringj
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')
map('n', '<leader>n', '<cmd>nohlsearch<CR>', { desc = 'Disable search highlight' })

-- move  selected block
map('v', 'J', [[:m '>+1<CR>gv=gv]], { desc = 'Move selection line down' })
map('v', 'K', [[:m '<-2<CR>gv=gv]], { desc = 'Move selection line up' })
map('n', 'J', 'mzJ`z', { desc = 'Join line and keep cursor position' })

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
map("n", "<C-f>", function()
  if vim.env.TMUX == nil then
    return
  end
  vim.cmd("silent !tmux display-popup -E tmux-sessionizer")
end, { noremap = true, silent = true, desc = 'tmux-sessionizer' })

map('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Replace word under cursor' })
map('n', '<leader>X', '<cmd>!chmod +x %<CR>', { desc = 'Make file executable', silent = true })

map('n', '<leader>F', vim.lsp.buf.format, { desc = 'Format with lsp' })
-- quickfix entry
map('n', ']q', '<cmd>cnext<CR>zz')
map('n', '[q', '<cmd>cprev<CR>zz')
-- location list entry
map('n', ']l', '<cmd>lnext<CR>zz')
map('n', '[l', '<cmd>lprev<CR>zz')
-- diagnostics entry
map('n', ']d', function()
  vim.diagnostic.goto_next()
  vim.cmd('normal! zz')
end)
map('n', '[d', function()
  vim.diagnostic.goto_prev()
  vim.cmd('normal! zz')
end)

-- save file with sudo instead of reopening
vim.cmd([[
  command! WForce execute ':silent w !$(command -v sudo || command -v doas) tee % > /dev/null' |
        \ execute 'wundo ' . fnameescape(undofile(expand('%'))) |
        \ edit!

  command! WForceQuit execute 'WForce' | quit!

  cmap w!! WForce
  cmap WQ! WForceQuit
]])

-- block cursor keys
map({'n','i','v'}, '<Up>',    [[<cmd>echo 'Use k'<CR>]])
map({'n','i','v'}, '<Down>',  [[<cmd>echo 'Use j'<CR>]])
map({'n','i','v'}, '<Left>',  [[<cmd>echo 'Use h'<CR>]])
map({'n','i','v'}, '<Right>', [[<cmd>echo 'Use l'<CR>]])
