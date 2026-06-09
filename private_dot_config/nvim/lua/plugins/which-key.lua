require('which-key').setup({
    preset = 'modern',
    spec = {
        { '<leader><Tab>', group = 'tabs' },
        { '<leader>b', group = 'buffers' },
        { '<leader>c', group = 'code / LSP' },
        { '<leader>d', group = 'debugger' },
        { '<leader>e', group = 'explorer' },
        { '<leader>f', group = 'find' },
        { '<leader>g', group = 'git' },
        { '<leader>gg', group = 'git pickers' },
        { '<leader>q', group = 'quit / sessions' },
        { '<leader>s', group = 'search' },
        { '<leader>t', group = 'tests' },
        { '<leader>u', group = 'UI toggles' },
        { '<leader>v', group = 'registers / void' },
        { '<leader>w', group = 'windows' },
        { '<leader>x', group = 'diagnostics / lists' },
    },
    win = {
        border = 'rounded',
    },
})
