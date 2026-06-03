local colors = require('catppuccin.palettes').get_palette('macchiato')

vim.api.nvim_set_hl(0, 'NoiceCmdlinePopup', { bg = 'NONE', fg = colors.text })
vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorder', { bg = 'NONE', fg = colors.blue })
vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupTitle', { bg = 'NONE', fg = colors.sapphire })
vim.api.nvim_set_hl(0, 'NoiceCmdlineIcon', { fg = colors.blue })
vim.api.nvim_set_hl(0, 'NoiceCmdlineIconCmdline', { fg = colors.blue })
vim.api.nvim_set_hl(0, 'NoicePopupmenu', { bg = 'NONE', fg = colors.text })
vim.api.nvim_set_hl(0, 'NoicePopupmenuBorder', { bg = 'NONE', fg = colors.blue })
vim.api.nvim_set_hl(0, 'NoicePopupmenuSelected', { bg = colors.surface0, fg = colors.text })
vim.api.nvim_set_hl(0, 'NoicePopupmenuMatch', { bg = 'NONE', fg = colors.peach })
vim.api.nvim_set_hl(0, 'NoiceCompletionItemKindDefault', { fg = colors.sapphire })
vim.api.nvim_set_hl(0, 'NoiceCompletionItemMenu', { fg = colors.overlay1 })

require('noice').setup({
    lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
        },
    },
    -- you can enable a preset for easier configuration
    presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = false,      -- cmdline and popupmenu are positioned below
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false,       -- add a border to hover docs and signature help
    },
    cmdline = {
        format = {
            cmdline = { pattern = '^:', icon = ':', lang = 'vim' },
        },
    },
    popupmenu = {
        enabled = false,
        backend = 'nui',
    },
    views = {
        cmdline_popup = {
            relative = 'win',
            position = {
                row = -3,
                col = 0.5,
            },
            size = {
                width = 0.8,
                height = 'auto',
            },
            border = {
                style = 'rounded',
                padding = { 0, 1 },
            },
            win_options = {
                winhighlight = {
                    Normal = 'NoiceCmdlinePopup',
                    FloatBorder = 'NoiceCmdlinePopupBorder',
                    FloatTitle = 'NoiceCmdlinePopupTitle',
                    IncSearch = '',
                    CurSearch = '',
                    Search = '',
                },
            },
        },
        cmdline_popupmenu = {
            relative = 'editor',
            position = {
                row = 8,
                col = '50%',
            },
            size = {
                width = 60,
                height = 10,
            },
            border = {
                style = 'rounded',
                padding = { 0, 1 },
            },
            win_options = {
                winhighlight = {
                    Normal = 'NoicePopupmenu',
                    FloatBorder = 'NoicePopupmenuBorder',
                    CursorLine = 'NoicePopupmenuSelected',
                    PmenuMatch = 'NoicePopupmenuMatch',
                },
            },
        },
    },
})
