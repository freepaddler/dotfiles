
local plugins = {
    {
        'nvim-telescope/telescope.nvim', tag = 'v0.1.9',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('plugins.telescope')
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'master', lazy = false, build = ":TSUpdate",
        config = function()
            require('plugins.treesitter')
        end,
    },
    {
        'mbbill/undotree',
        config = function()
            require('plugins.undotree')
        end,
    },
    {
        'tpope/vim-fugitive',
        config = function()
            require('plugins.fugitive')
        end,
    },
    {
        'csexton/trailertrash.vim',
        config = function()
            -- enable/disable highlighting on startup
            vim.g.show_trailertrash = 1
        end,
    },
-- ui
    -- themes
    {
        'gbprod/nord.nvim',
        enabled = false, lazy = false, priority = 1000,
        config = function()
            require('plugins.nord')
        end,
    },
    {
        'catppuccin/nvim', name = 'catppuccin',
        enabled = true, lazy = false, priority = 1000,
        config = function()
            require('plugins.catppuccin')
        end,
    },
    -- status line
    {
        'nvim-lualine/lualine.nvim',
        enabled = true, lazy = false,
        config = function()
            require('plugins.lualine')
        end,
    }
}

local options = {
    ui = { border = 'rounded' },
}

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
            { out, 'WarningMsg' },
            { '\nPress any key to exit...' },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup(plugins,options)
