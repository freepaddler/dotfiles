return {
    mason = {
        lsp = { 'marksman' },
        tools = { 'markdownlint-cli2', 'markdown-toc', 'prettier' },
    },
    lsp = {
        marksman = {},
    },
    formatters = {
        ['markdown-toc'] = {
            condition = function(_, ctx)
                for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
                    if line:find('<!%-%- toc %-%->') then
                        return true
                    end
                end
            end,
        },
        ['markdownlint-cli2'] = {
            condition = function(_, ctx)
                local diagnostics = vim.tbl_filter(function(diagnostic)
                    return diagnostic.source == 'markdownlint'
                end, vim.diagnostic.get(ctx.buf))
                return #diagnostics > 0
            end,
        },
    },
    formatters_by_ft = {
        markdown = { 'prettier', 'markdownlint-cli2', 'markdown-toc' },
        ['markdown.mdx'] = { 'prettier', 'markdownlint-cli2', 'markdown-toc' },
    },
    linters_by_ft = {
        markdown = { 'markdownlint-cli2' },
    },
}
