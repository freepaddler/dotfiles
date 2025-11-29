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

local options = {
    ui = { border = 'rounded' },
}

local plugins = {
    {
        'csexton/trailertrash.vim',
        config = function()
            -- enable/disable highlighting on startup
            vim.g.show_trailertrash = 1
        end,
    },
    {
        'nvim-telescope/telescope.nvim', tag = 'v0.1.9',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('chu.plugins.telescope')
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'master', lazy = false, build = ":TSUpdate",
        config = function()
            require('chu.plugins.treesitter')
        end,
    },
    {
        'mbbill/undotree',
        config = function()
            require('chu.plugins.undotree')
        end,
    },
-- ui
    -- themes
    {
        'arcticicestudio/nord-vim',
        enabled = false, lazy = false, priority = 1000,
    },
    {
        'shaunsingh/nord.nvim', name = 'nord1',
        enabled = false, lazy = false, priority = 1000,
        config = function()
            require('chu.plugins.nord1')
        end,
    },
    {
        'gbprod/nord.nvim', name = 'nord2',
        enabled = true, lazy = false, priority = 1000,
        config = function()
            require('chu.plugins.nord2')
        end,
    },
    -- status line
    {
        'itchyny/lightline.vim',
        enabled = true, lazy = false,
        config = function()
            require('chu.plugins.lightline')
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        enabled = false, lazy = false,
        config = function()
            require('chu.plugins.lualine')
        end,
    }
}

require('lazy').setup(plugins,options)
