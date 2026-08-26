return {
    mason = {
        lsp = { 'terraformls' },
        tools = { 'tflint' },
    },
    lsp = {
        terraformls = {},
    },
    filetypes = {
        extension = {
            tf = 'terraform',
        },
    },
    formatters_by_ft = {
        terraform = { 'terraform_fmt' },
        ['terraform-vars'] = { 'terraform_fmt' },
    },
    linters_by_ft = {
        terraform = { 'tflint' },
    },
}
