local cmp = require('cmp')

vim.keymap.set('i', '<C-s>', function()
    cmp.complete({
        config = {
            sources = {
                { name = 'luasnip' },
            },
        },
    })
end, { desc = 'Complete snippets only' })

local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
    -- No external snippet engine needed.
    -- Neovim 0.11 has built-in snippet support via vim.snippet.
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered({
            max_height = vim.g.ui_docs_max_height,
            max_width = vim.g.ui_docs_max_width,
        }),
    },

    view = {
        entries = {
            follow_cursor = true,
        },
    },

    mapping = cmp.mapping.preset.insert({
        ['<C-k>'] = cmp.mapping.scroll_docs(-1),
        ['<C-j>'] = cmp.mapping.scroll_docs(1),
        ['<C-u>'] = cmp.mapping.scroll_docs(-20),
        ['<C-d>'] = cmp.mapping.scroll_docs(20),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-@>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        -- Replace-style confirm (overwrite to the right)
        ['<C-y>'] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace,
        }),
        ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                if luasnip.expandable() then
                    luasnip.expand()
                else
                    cmp.confirm({
                        select = true,
                        behavior = cmp.ConfirmBehavior.Insert,
                    })
                end
            else
                fallback()
            end
        end),

        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
    }, {
        { name = 'buffer' },
    }),
})

-- Cmdline completion is rendered by noice.nvim's nui popupmenu.
-- Keep the cmp cmdline setup here as a reference if you want to switch back.
--
-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})
