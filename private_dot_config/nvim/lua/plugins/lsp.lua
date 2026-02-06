local map = vim.keymap.set

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

---- packages
require('mason').setup({
    ui = {
        icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗'
        }
    },
})

require('mason-lspconfig').setup({
    ensure_installed = {
        'lua_ls', 'bashls',
        'dockerls', 'docker_compose_language_service',
    },
    automatic_enable = {
        exclude = {
            'docker_language_server',
        },
    },
})

---- lsp
vim.lsp.config('lua_ls', {
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            format = {
                enable = true,
                defaultConfig = {
                    indent_style = 'space',
                    indent_size = '4',
                    quote_style = 'single',
                },
            },
        },
    },
})

vim.lsp.config('bashls', {
    capabilities = capabilities,
})

vim.lsp.config('dockerls', {
    capabilities = capabilities,
})

vim.lsp.config('docker_language_server', {
    capabilities = capabilities,
})

vim.lsp.config('docker_compose_language_service', {
    capabilities = capabilities,
})

---- format
local conform = require('conform')
conform.setup({
    formatters = {
        shfmt = {
            append_args = { '-i', '4', '-ci', '-sr' },
        },
    },
    format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
    },
    formatters_by_ft = {
        json = { 'prettier' },
        jsonc = { 'prettier' },
        -- yaml = { 'prettier' },
        markdown = { 'prettier' },
        html = { 'prettier' },
        css = { 'prettier' },

        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        vue = { 'prettier' },

        sh = { 'shfmt' },
        bash = { 'shfmt' },
    },
})

map('n', '<leader>F', function()
    conform.format({ lsp_fallback = true, async = false })
end, { desc = 'Format with conform (LSP fallback)' })

---- lint
local lint = require('lint')
lint.linters_by_ft = {
    dockerfile = { 'hadolint' },
}

map('n', '<leader>L', lint.try_lint, { desc = 'lint.try_lint' })

---- code actions
require('null-ls').setup({
    sources = {
        require('none-ls-shellcheck.code_actions').with({
            filetypes = { 'sh', 'bash' },
        }),
    },
})

-- keymaps
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
        local bufmap = function(mode, lhs, rhs, opts)
            opts = opts or {}
            opts.buffer = event.buf
            opts.silent = opts.silent ~= false
            vim.keymap.set(mode, lhs, rhs, opts)
        end
        --bufmap('n', '<leader>F', vim.lsp.buf.format, { desc = 'vim.lsp.buf.format' })
        bufmap('n', 'K', function()
            vim.lsp.buf.hover({
                max_height = vim.g.ui_docs_max_height,
                max_width = vim.g.ui_docs_max_width,
            })
        end, { desc = 'vim.lsp.buf.hover' })
        bufmap('n', 'gd', vim.lsp.buf.definition, { desc = 'vim.lsp.buf.definition' })
        bufmap('n', 'gD', vim.lsp.buf.declaration, { desc = 'vim.lsp.buf.declaration' })
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
