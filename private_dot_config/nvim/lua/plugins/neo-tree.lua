vim.keymap.set('n', '<leader>et', ':Neotree toggle filesystem reveal left<CR>', { desc = 'Toggle file tree' })
vim.keymap.set('n', '<leader>ef', ':Neotree filesystem reveal left<CR>', { desc = 'Reveal current file' })
vim.keymap.set('n', '<leader>eb', ':Neotree buffers reveal float<CR>', { desc = 'Open buffer tree' })

require('neo-tree').setup({
    filesystem = {
        hijack_netrw_behavior = 'disabled',
    },
})
