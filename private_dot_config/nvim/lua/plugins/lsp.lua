-- keymaps
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local bufmap = function(mode, lhs, rhs, opts)
            opts = opts or {}
            opts.buffer = event.buf
            opts.silent = opts.silent ~= false
            vim.keymap.set(mode, lhs, rhs, opts)
        end
        bufmap('n', '<leader>F', vim.lsp.buf.format, { desc = 'vim.lsp.buf.format' })
        bufmap('n', 'K', function()
            vim.lsp.buf.hover { max_height = 25, max_width = 120 }
        end, { desc = 'vim.lsp.buf.hover' })
        bufmap('n', 'gd', vim.lsp.buf.definition, { desc = 'vim.lsp.buf.definition' })
        bufmap('n', 'gD', vim.lsp.buf.declaration, { desc = 'vim.lsp.buf.declaration' })
    end,
})

-- Diagnostics UI
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

-- Capabilities: tell LSP servers that nvim-cmp can handle completion features.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        'lua_ls',
        'bashls',
    },
    automatic_installation = true,
})

-- Lua (Neovim config)
vim.lsp.config('lua_ls', {
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
})

-- Bash / POSIX shell
vim.lsp.config('bashls', {
    capabilities = capabilities,
})
