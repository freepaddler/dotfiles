require('settings')
require('keymap')
require('packages')

--vim.cmd.colorscheme 'nord'
vim.cmd.colorscheme('catppuccin')

-- higlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 200,
        })
    end,
})
