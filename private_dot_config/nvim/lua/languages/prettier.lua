local prettier_filetypes = {
    'css',
    'graphql',
    'handlebars',
    'html',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'less',
    'scss',
    'typescript',
    'typescriptreact',
    'vue',
    'yaml',
}

local formatters_by_ft = {}
for _, filetype in ipairs(prettier_filetypes) do
    formatters_by_ft[filetype] = { 'prettier' }
end

return {
    mason = {
        tools = { 'prettier' },
    },
    formatters_by_ft = formatters_by_ft,
}
