local module_names = {
    'languages.lua',
    'languages.shell',
    'languages.docker',
    'languages.markdown',
    'languages.prettier',
}

local config = {
    lsp = {},
    mason = {
        lsp = {},
        tools = {},
    },
    formatters = {},
    formatters_by_ft = {},
    filetypes = {},
    linters_by_ft = {},
    none_ls = {},
}

local function append_unique(target, additions)
    for _, value in ipairs(additions or {}) do
        if not vim.list_contains(target, value) then
            table.insert(target, value)
        end
    end
end

local function extend_by_filetype(target, additions)
    for filetype, values in pairs(additions or {}) do
        target[filetype] = target[filetype] or {}
        append_unique(target[filetype], values)
    end
end

for _, module_name in ipairs(module_names) do
    local language = require(module_name)

    config.lsp = vim.tbl_deep_extend('force', config.lsp, language.lsp or {})
    config.formatters = vim.tbl_deep_extend('force', config.formatters, language.formatters or {})
    config.filetypes = vim.tbl_deep_extend('force', config.filetypes, language.filetypes or {})

    append_unique(config.mason.lsp, language.mason and language.mason.lsp)
    append_unique(config.mason.tools, language.mason and language.mason.tools)
    append_unique(config.none_ls, language.none_ls)
    extend_by_filetype(config.formatters_by_ft, language.formatters_by_ft)
    extend_by_filetype(config.linters_by_ft, language.linters_by_ft)
end

vim.filetype.add(config.filetypes)

return config
