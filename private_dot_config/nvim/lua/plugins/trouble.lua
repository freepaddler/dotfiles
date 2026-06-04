local trouble = require('trouble')

trouble.setup({
    modes = {
        lsp = {
            win = { position = 'right' },
        },
    },
})

vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', { desc = 'Buffer diagnostics' })
vim.keymap.set('n', '<leader>cs', '<cmd>Trouble symbols toggle<CR>', { desc = 'Symbols' })
vim.keymap.set('n', '<leader>cS', '<cmd>Trouble lsp toggle<CR>', { desc = 'LSP references / definitions' })
vim.keymap.set('n', '<leader>xL', '<cmd>Trouble loclist toggle<CR>', { desc = 'Location list' })
vim.keymap.set('n', '<leader>xQ', '<cmd>Trouble qflist toggle<CR>', { desc = 'Quickfix list' })

vim.keymap.set('n', '[q', function()
    if trouble.is_open() then
        trouble.prev({ skip_groups = true, jump = true })
    else
        local ok, err = pcall(vim.cmd.cprev)
        if not ok then
            vim.notify(err, vim.log.levels.ERROR)
        end
    end
end, { desc = 'Previous Trouble / quickfix item' })

vim.keymap.set('n', ']q', function()
    if trouble.is_open() then
        trouble.next({ skip_groups = true, jump = true })
    else
        local ok, err = pcall(vim.cmd.cnext)
        if not ok then
            vim.notify(err, vim.log.levels.ERROR)
        end
    end
end, { desc = 'Next Trouble / quickfix item' })
