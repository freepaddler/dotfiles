local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fp', builtin.git_files, { desc = 'Telescope find git files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fm', builtin.keymaps, { desc = 'Telescope help keymaps' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- remap split/vsplit
local actions = require("telescope.actions")
require('telescope').setup({
    defaults = {
        hidden = true,
        mappings = {
            i = {
                ['<C-\\>'] = actions.select_vertical,   -- instead of <C-v>
                ['<C-->'] = actions.select_horizontal,  -- instead of <C-y>
                ['<C-v>'] = false,                      -- disable original
                ['<C-y>'] = false,
            },
            n = {
                ['<C-\\>'] = actions.select_vertical,
                ['<C-->'] = actions.select_horizontal,
                ['<C-v>'] = false,
                ['<C-y>'] = false,
            },
        },
    },
    pickers = {
        find_files = {
            hidden = true,
        },
    },
})
