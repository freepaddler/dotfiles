vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local map = vim.keymap.set

-- Helpers
local function explore(path, new_tab)
    if new_tab then
        vim.cmd.tabnew()
    end
    vim.cmd.Explore(vim.fn.fnameescape(path))
end

local function current_file_dir()
    local path = vim.fn.expand('%:p:h')
    return path ~= '' and path or vim.fn.getcwd()
end

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

-- General
map('n', '<C-s>', '<cmd>write<CR>', { desc = 'Save file' })
map('n', '<leader>-', '<cmd>split<CR>', { desc = 'Split window horizontally' })
map('n', '<leader>\\', '<cmd>vsplit<CR>', { desc = 'Split window vertically' })

-- Leave insert mode
map('i', '<C-c>', '<Esc>')
map('i', 'jj', '<Esc>')
map('i', 'jk', '<Esc>')

-- Movement and editing
map({ 'n', 'v' }, 'j', 'gj')
map({ 'n', 'v' }, 'k', 'gk')
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')
map('v', 'J', [[:m '>+1<CR>gv=gv]], { desc = 'Move selection line down' })
map('v', 'K', [[:m '<-2<CR>gv=gv]], { desc = 'Move selection line up' })
map('n', 'J', 'mzJ`z', { desc = 'Join line and keep cursor position' })

-- Block cursor keys for navigation, but keep them available in insert-mode prompts
map({ 'n', 'v' }, '<Up>', [[<cmd>echo 'Use k'<CR>]])
map({ 'n', 'v' }, '<Down>', [[<cmd>echo 'Use j'<CR>]])
map({ 'n', 'v' }, '<Left>', [[<cmd>echo 'Use h'<CR>]])
map({ 'n', 'v' }, '<Right>', [[<cmd>echo 'Use l'<CR>]])

-- Window and tmux pane navigation
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

-- Clipboard
map({ 'n', 'v' }, '<leader>y', [["+y]], { desc = 'Yank to clipboard' })
map('n', '<leader>Y', [["+Y]], { desc = 'Yank until EOF to clipboard' })
map({ 'n', 'v' }, '<leader>p', [["+p]], { desc = 'Paste after from clipboard' })
map('n', '<leader>P', [["+P]], { desc = 'Paste before from clipboard' })
map('x', '<leader>p', [["_dP]], { desc = 'Replace without yanking' })

-- Registers / void
map({ 'n', 'x' }, '<leader>vd', [["_d]], { desc = 'Delete without yanking' })
map('n', '<leader>vD', [["_D]], { desc = 'Delete until EOL without yanking' })
map({ 'n', 'x' }, '<leader>vc', [["_c]], { desc = 'Change without yanking' })
map('n', '<leader>vC', [["_C]], { desc = 'Change until EOL without yanking' })
map({ 'n', 'x' }, '<leader>vy', [["+y]], { desc = 'Yank to clipboard' })
map('n', '<leader>vY', [["+Y]], { desc = 'Yank until EOF to clipboard' })
map({ 'n', 'x' }, '<leader>vp', [["+p]], { desc = 'Paste after from clipboard' })
map('n', '<leader>vP', [["+P]], { desc = 'Paste before from clipboard' })

-- Buffers
map('n', '[b', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
map('n', ']b', '<cmd>bnext<CR>', { desc = 'Next buffer' })
map('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Delete current buffer' })
map('n', '<leader>bD', function()
    local current = vim.api.nvim_get_current_buf()
    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        if buffer ~= current and vim.bo[buffer].buflisted then
            vim.api.nvim_buf_delete(buffer, {})
        end
    end
end, { desc = 'Delete other buffers' })
map('n', '<leader>bn', ':bnext<CR>', { desc = 'Next buffer' })
map('n', '<leader>bp', ':bprevious<CR>', { desc = 'Previous buffer' })
map('n', '<leader>bl', '<C-^>', { desc = 'Last buffer' })

-- Tabs
map('n', '[t', 'gT', { desc = 'Previous tab' })
map('n', ']t', 'gt', { desc = 'Next tab' })
map('n', '<leader><Tab>d', '<cmd>tabclose<CR>', { desc = 'Delete current tab' })
map('n', '<leader><Tab>D', '<cmd>tabonly<CR>', { desc = 'Delete other tabs' })
map('n', '<leader><Tab>c', '<cmd>tabnew<CR>', { desc = 'Create tab' })
map('n', '<leader><Tab>e', function()
    explore(current_file_dir(), true)
end, { desc = 'Open current file directory in new tab' })
map('n', '<leader><Tab>E', function()
    explore(vim.fn.getcwd(), true)
end, { desc = 'Open working directory in new tab' })
map('n', '<leader><Tab>gf', '<C-w>gf', { desc = 'Go to file in new tab' })
map('n', '<leader><Tab>n', 'gt', { desc = 'Next tab' })
map('n', '<leader><Tab>p', 'gT', { desc = 'Previous tab' })

-- Track last active tab
vim.g.lasttab = 1
vim.api.nvim_create_autocmd('TabLeave', {
    callback = function()
        vim.g.lasttab = vim.fn.tabpagenr()
    end,
})
map('n', '<leader><Tab><Tab>', function()
    vim.cmd('tabn ' .. vim.g.lasttab)
end, { desc = 'Last tab' })
map('n', '<leader><Tab>1', '1gt', { desc = 'Go to tab 1' })
map('n', '<leader><Tab>2', '2gt', { desc = 'Go to tab 2' })
map('n', '<leader><Tab>3', '3gt', { desc = 'Go to tab 3' })
map('n', '<leader><Tab>4', '4gt', { desc = 'Go to tab 4' })
map('n', '<leader><Tab>5', '5gt', { desc = 'Go to tab 5' })
map('n', '<leader><Tab>6', '6gt', { desc = 'Go to tab 6' })
map('n', '<leader><Tab>7', '7gt', { desc = 'Go to tab 7' })
map('n', '<leader><Tab>8', '8gt', { desc = 'Go to tab 8' })
map('n', '<leader><Tab>9', '9gt', { desc = 'Go to tab 9' })

-- Explorer
map('n', '<leader>ee', function()
    explore(current_file_dir(), false)
end, { desc = 'Open current file directory' })
map('n', '<leader>eE', function()
    explore(vim.fn.getcwd(), false)
end, { desc = 'Open working directory' })

-- Search
map({ 'n', 'x' }, '<leader>sr', function()
    local extension = vim.bo.buftype == '' and vim.fn.expand('%:e')
    require('grug-far').open({
        transient = true,
        prefills = {
            filesFilter = extension and extension ~= '' and '*.' .. extension or nil,
        },
    })
end, { desc = 'Search and replace current file type' })
map({ 'n', 'x' }, '<leader>sR', function()
    require('grug-far').open({ transient = true })
end, { desc = 'Search and replace all files' })
map('n', '<leader>ss', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Substitute word under cursor' })

-- UI toggles
map('n', '<leader>ud', function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = 'Toggle diagnostics' })
map('n', '<leader>uh', function()
    vim.opt.hlsearch = not vim.opt.hlsearch:get()
end, { desc = 'Toggle search highlight' })
map('n', '<leader>ul', function()
    vim.opt.number = not vim.opt.number:get()
end, { desc = 'Toggle line numbers' })
map('n', '<leader>uL', function()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = 'Toggle relative line numbers' })

-- Code
map('n', '<leader>cX', '<cmd>!chmod +x %<CR>', { desc = 'Make file executable', silent = true })

-- Diagnostics / lists
map('n', ']l', '<cmd>lnext<CR>zz', { desc = 'Next location' })
map('n', '[l', '<cmd>lprev<CR>zz', { desc = 'Previous location' })

map('n', ']d', function()
    vim.diagnostic.goto_next()
    vim.cmd('normal! zz')
end, { desc = 'Next diagnostic' })
map('n', '[d', function()
    vim.diagnostic.goto_prev()
    vim.cmd('normal! zz')
end, { desc = 'Previous diagnostic' })

-- Tmux-sessionizer
--map('n', '<M-f>', function()
--    if vim.env.TMUX == nil then
--        return
--    end
--    vim.cmd('silent !tmux display-popup -E tmux-sessionizer')
--end, { noremap = true, silent = true, desc = 'tmux-sessionizer' })

-- Save file with sudo instead of reopening
vim.cmd([[
  command! WForce execute ':silent w !$(command -v sudo || command -v doas) tee % > /dev/null' |
        \ execute 'wundo ' . fnameescape(undofile(expand('%'))) |
        \ edit!

  command! WForceQuit execute 'WForce' | quit!

  cmap w!! WForce
  cmap WQ! WForceQuit
]])
