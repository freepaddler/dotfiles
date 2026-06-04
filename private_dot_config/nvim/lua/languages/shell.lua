return {
    mason = {
        lsp = { 'bashls' },
        tools = { 'shellcheck', 'shfmt' },
    },
    lsp = {
        bashls = {},
    },
    formatters = {
        shfmt = {
            append_args = { '-i', '4', '-ci', '-sr' },
        },
    },
    formatters_by_ft = {
        sh = { 'shfmt' },
        bash = { 'shfmt' },
    },
    none_ls = {
        function()
            return require('none-ls-shellcheck.code_actions').with({
                filetypes = { 'sh', 'bash' },
            })
        end,
    },
}
