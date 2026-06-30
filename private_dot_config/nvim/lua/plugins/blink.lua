require('blink.cmp').setup({
    keymap = {
        preset = 'none',
        ['<C-s>'] = {
            function(cmp)
                return cmp.show({ providers = { 'snippets' } })
            end,
        },
        ['<C-k>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-j>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-u>'] = {
            function(cmp)
                return cmp.scroll_documentation_up(20)
            end,
            'fallback',
        },
        ['<C-d>'] = {
            function(cmp)
                return cmp.scroll_documentation_down(20)
            end,
            'fallback',
        },
        ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-@>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<C-y>'] = { 'select_and_accept', 'fallback' },
        ['<CR>'] = { 'select_and_accept', 'fallback' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
    },
    completion = {
        documentation = {
            auto_show = false,
            window = {
                border = 'rounded',
                max_width = vim.g.ui_docs_max_width,
                max_height = vim.g.ui_docs_max_height,
            },
        },
        menu = {
            border = 'rounded',
        },
    },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        per_filetype = {
            sql = { 'snippets', 'dadbod', 'buffer' },
            mysql = { 'snippets', 'dadbod', 'buffer' },
            plsql = { 'snippets', 'dadbod', 'buffer' },
        },
        providers = {
            dadbod = {
                name = 'Dadbod',
                module = 'vim_dadbod_completion.blink',
            },
        },
    },
    fuzzy = {
        implementation = 'prefer_rust_with_warning',
    },
})
