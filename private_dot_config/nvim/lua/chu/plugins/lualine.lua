require('lualine').setup({
    options = {
        theme = 'nord',
        icons_enabled = false,
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
    },
})

vim.opt.showmode = false
