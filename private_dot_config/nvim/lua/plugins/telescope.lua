local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fp', builtin.git_files, { desc = 'Find Git files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fm', builtin.keymaps, { desc = 'Search keymaps' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Search help' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Find recent files' })
vim.keymap.set('n', '<leader>vr', builtin.registers, { desc = 'Search registers' })

-- remap split/vsplit
local actions = require('telescope.actions')
require('telescope').setup({
    defaults = {
        hidden = true,
        prompt_prefix = '🔍 ',
        mappings = {
            i = {
                ['<C-\\>'] = actions.select_vertical,  -- instead of <C-v>
                ['<C-->'] = actions.select_horizontal, -- instead of <C-y>
                ['<C-v>'] = false,                     -- disable original
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
    extensions = {
        ['ui-select'] = {
            require('telescope.themes').get_cursor {}
        }
    }
})

require('telescope').load_extension('ui-select')
