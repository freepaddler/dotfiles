local languages = require('languages')

require('mason').setup({
    ui = {
        icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗'
        }
    },
})

require('mason-tool-installer').setup({
    ensure_installed = languages.mason.tools,
})
