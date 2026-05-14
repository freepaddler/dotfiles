local treesitter = require('nvim-treesitter')

treesitter.setup({
    install_dir = vim.fn.stdpath('data') .. '/site',
})

local parsers = {
    'bash',
    'go',
    'lua',
    'markdown',
    'markdown_inline',
    'query',
    'vim',
    'vimdoc',
}

treesitter.install(parsers)

local ft_to_lang = {
    bash = 'bash',
    go = 'go',
    help = 'vimdoc',
    lua = 'lua',
    markdown = 'markdown',
    sh = 'bash',
    vim = 'vim',
    vimdoc = 'vimdoc',
}

vim.api.nvim_create_autocmd('FileType', {
    pattern = vim.tbl_keys(ft_to_lang),
    callback = function(event)
        local lang = ft_to_lang[vim.bo[event.buf].filetype]
        if not lang then
            return
        end

        pcall(vim.treesitter.start, event.buf, lang)
        pcall(function()
            vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end)
    end,
})
