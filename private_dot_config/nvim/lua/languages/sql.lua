return {
    mason = {
        tools = { 'sqlfluff' },
    },
    formatters = {
        sqlfluff = {
            args = { 'format', '-' },
            exit_codes = { 0, 1 },
            require_cwd = false,
        },
    },
    formatters_by_ft = {
        sql = { 'sqlfluff' },
    },
    linters_by_ft = {
        sql = { 'sqlfluff' },
    },
}
