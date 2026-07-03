local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fm', builtin.keymaps, { desc = 'Search keymaps' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Search help' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Find recent files' })
vim.keymap.set('n', '<leader>vr', builtin.registers, { desc = 'Search registers' })

vim.keymap.set('n', '<leader>ggf', builtin.git_files, { desc = 'Find Git files' })
vim.keymap.set('n', '<leader>ggs', builtin.git_status, { desc = 'Find Git status files' })
vim.keymap.set('n', '<leader>ggl', builtin.git_commits, { desc = 'Find Git log' })
vim.keymap.set('n', '<leader>ggF', builtin.git_bcommits, { desc = 'Find current file Git log' })
vim.keymap.set({ 'n', 'x' }, '<leader>ggL', builtin.git_bcommits_range, { desc = 'Find current line Git log' })
vim.keymap.set('n', '<leader>ggb', builtin.git_branches, { desc = 'Find Git branches' })
vim.keymap.set('n', '<leader>ggS', builtin.git_stash, { desc = 'Find Git stash' })

-- remap split/vsplit
local actions = require('telescope.actions')
require('telescope').setup({
    defaults = {
        hidden = true,
        prompt_prefix = '🔍 ',
        mappings = {
            i = {
                ['<C-v>'] = actions.select_vertical,
                ['<C-h>'] = actions.select_horizontal,
                ['<C-Tab>'] = actions.select_tab,
                ['<C-y>'] = false,
            },
            n = {
                ['<C-v>'] = actions.select_vertical,
                ['<C-h>'] = actions.select_horizontal,
                ['<C-Tab>'] = actions.select_tab,
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
