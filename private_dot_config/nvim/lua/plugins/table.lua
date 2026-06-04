require('table-nvim').setup({
    mappings = {
        next = '<Tab>',
        prev = '<S-Tab>',
        insert_row_up = '<C-A-U>',
        insert_row_down = '<C-A-D>',
        move_row_up = '<C-A-K>',
        move_row_down = '<C-A-J>',
        insert_column_left = '<C-A-I>',
        insert_column_right = '<C-A-A>',
        move_column_left = '<C-A-H>',
        move_column_right = '<C-A-L>',
        insert_table = '<C-A-N>',
        insert_table_alt = false,
        delete_column = '<C-A-X>',
    },
})
