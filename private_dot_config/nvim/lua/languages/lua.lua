return {
    mason = {
        lsp = { 'lua_ls' },
    },
    lsp = {
        lua_ls = {
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
        },
    },
}
