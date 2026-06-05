local plugins = {
    {
        'williamboman/mason.nvim',
        lazy = false,
        priority = 1000,
        dependencies = {
            'WhoIsSethDaniel/mason-tool-installer.nvim',
        },
        config = function()
            require('plugins.mason')
        end,
    },
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
        'andre-kotake/nvim-chezmoi',
        main = 'nvim-chezmoi',
        event = 'VeryLazy',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
        },
        keys = {
            {
                '<leader>fz',
                '<cmd>ChezmoiManaged<CR>',
                desc = 'Find chezmoi managed files',
            },
        },
        opts = {
            edit = {
                apply_on_save = 'never',
            },
        },
    },
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        lazy = false,
        build = ':TSUpdate',
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
        'MagicDuck/grug-far.nvim',
        cmd = { 'GrugFar', 'GrugFarWithin' },
        config = function()
            require('plugins.grug-far')
        end,
    },
    {
        'iamcco/markdown-preview.nvim',
        ft = { 'markdown' },
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
        build = function()
            require('lazy').load({ plugins = { 'markdown-preview.nvim' } })
            vim.fn['mkdp#util#install']()
        end,
        keys = {
            {
                '<leader>cp',
                '<cmd>MarkdownPreviewToggle<CR>',
                ft = 'markdown',
                desc = 'Markdown preview',
            },
        },
        config = function()
            require('plugins.markdown-preview')
        end,
    },
    {
        'SCJangra/table-nvim',
        ft = { 'markdown' },
        config = function()
            require('plugins.table')
        end,
    },
    {
        'folke/snacks.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('plugins.snacks')
        end,
    },
    {
        'folke/trouble.nvim',
        cmd = { 'Trouble' },
        event = 'VeryLazy',
        config = function()
            require('plugins.trouble')
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
            'nvim-lua/plenary.nvim',
            'MunifTanjim/nui.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        lazy = false,
        config = function()
            require('plugins.neo-tree')
        end,
    },
    -- completions
    {
        'hrsh7th/nvim-cmp',
        enabled = false,
        dependencies = {
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp',

            -- snippets
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets',
        },
        config = function()
            require('plugins.cmp')
        end,
    },
    {
        'saghen/blink.cmp',
        version = '1.*',
        dependencies = {
            'rafamadriz/friendly-snippets',
        },
        config = function()
            require('plugins.blink')
        end,
    },
    -- lsp
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
            'saghen/blink.cmp',
            -- formatter
            'stevearc/conform.nvim',
            -- linter
            'mfussenegger/nvim-lint',
            -- code actions
            'nvimtools/none-ls.nvim',
            'gbprod/none-ls-shellcheck.nvim',
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
    },
    -- keymap hints
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        config = function()
            require('plugins.which-key')
        end,
    },
    -- command line
    {
        'folke/noice.nvim',
        enabled = false,
        event = 'VeryLazy',
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            'MunifTanjim/nui.nvim',
            'rcarriga/nvim-notify',
        },
        config = function()
            require('plugins.noice')
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
