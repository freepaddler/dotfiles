local map = vim.keymap.set
local languages = require('languages')

local capabilities = require('blink.cmp').get_lsp_capabilities()
-- local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

require('mason-lspconfig').setup({
    ensure_installed = languages.mason.lsp,
    automatic_enable = {
        exclude = {
            'docker_language_server',
        },
    },
})

---- lsp
for server, server_config in pairs(languages.lsp) do
    vim.lsp.config(server, vim.tbl_deep_extend('force', {
        capabilities = capabilities,
    }, server_config))
end

---- format
local conform = require('conform')
conform.setup({
    formatters = languages.formatters,
    format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
    },
    formatters_by_ft = languages.formatters_by_ft,
})

map('n', '<leader>cf', function()
    conform.format({ lsp_fallback = true, async = false })
end, { desc = 'Format buffer' })

---- lint
local lint = require('lint')
lint.linters_by_ft = languages.linters_by_ft

map('n', '<leader>cl', lint.try_lint, { desc = 'Lint buffer' })

---- code actions
local none_ls_sources = {}
for _, source_factory in ipairs(languages.none_ls) do
    table.insert(none_ls_sources, source_factory())
end

require('null-ls').setup({
    sources = none_ls_sources,
})

-- keymaps
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
        local bufmap = function(mode, lhs, rhs, opts)
            opts = opts or {}
            opts.buf = event.buf
            opts.silent = opts.silent ~= false
            vim.keymap.set(mode, lhs, rhs, opts)
        end
        --bufmap('n', '<leader>cf', vim.lsp.buf.format, { desc = 'vim.lsp.buf.format' })
        bufmap('n', 'K', function()
            vim.lsp.buf.hover({
                max_height = vim.g.ui_docs_max_height,
                max_width = vim.g.ui_docs_max_width,
            })
        end, { desc = 'Hover documentation' })
        bufmap('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
        bufmap('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
    end,
})

-- diagnostics ui
vim.diagnostic.config({
    underline = true,
    virtual_text = true, -- you can switch this off later if it feels noisy
    --signs = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '✘',
            [vim.diagnostic.severity.WARN] = '▲',
            [vim.diagnostic.severity.HINT] = '⚑',
            [vim.diagnostic.severity.INFO] = '»',
        },
    },
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded' },
})
