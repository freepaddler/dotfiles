local plugins = {
    {
        'nvim-telescope/telescope.nvim',
        tag = 'v0.1.9',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-ui-select.nvim',
        },
        config = function()
            require('plugins.telescope')
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'master',
        lazy = false,
        build = ":TSUpdate",
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
    {
        'nvim-neo-tree/neo-tree.nvim',
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        lazy = false,
        config = function()
            require('plugins.neo-tree')
        end,
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp',

            -- snippets
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            require('plugins.cmp')
        end,
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        },
        config = function()
            require('plugins.lsp')
        end,
    },
    -- ui
    -- themes
    {
        'gbprod/nord.nvim',
        enabled = false,
        lazy = false,
        priority = 1000,
        config = function()
            require('plugins.nord')
        end,
    },
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        enabled = true,
        lazy = false,
        priority = 1000,
        config = function()
            require('plugins.catppuccin')
        end,
    },
    -- status line
    {
        'nvim-lualine/lualine.nvim',
        enabled = true,
        lazy = false,
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
            { out,                            'WarningMsg' },
            { '\nPress any key to exit...' },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup(plugins, options)
