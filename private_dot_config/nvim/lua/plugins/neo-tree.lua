local function project_root()
    return vim.fs.root(0, { '.git' }) or vim.fn.getcwd()
end

vim.keymap.set('n', '<leader>et', function()
    require('neo-tree.command').execute({
        action = 'toggle',
        source = 'filesystem',
        position = 'left',
        dir = project_root(),
    })
end, { desc = 'Toggle file tree at project root' })
vim.keymap.set('n', '<leader>ef', ':Neotree filesystem reveal left<CR>', { desc = 'Reveal current file' })
vim.keymap.set('n', '<leader>eb', ':Neotree buffers reveal float<CR>', { desc = 'Open buffer tree' })
vim.keymap.set('n', '<leader>eg', ':Neotree git_status reveal left<CR>', { desc = 'Open Git status tree' })

require('neo-tree').setup({
    filesystem = {
        hijack_netrw_behavior = 'disabled',
    },
})
