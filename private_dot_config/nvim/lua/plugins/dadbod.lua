vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_show_database_icon = 1
vim.g.db_ui_use_nvim_notify = 1
vim.g.db_ui_execute_on_save = 0
vim.g.db_ui_disable_info_notifications = 1
vim.g.db_ui_save_location = vim.fn.stdpath('data') .. '/db_ui'
vim.g.db_ui_tmp_query_location = vim.fn.stdpath('run') .. '/db_ui_queries'

local function run_all()
    vim.cmd('%DB')
end

local function run_selection()
    vim.cmd("'<,'>DB")
end

local function execute_dbui_query(mode)
    if vim.b.dbui_db_key_name == nil then
        return false
    end

    local mapping = vim.fn.maparg('<Plug>(DBUI_ExecuteQuery)', mode, false, true)
    if vim.tbl_isempty(mapping) then
        return false
    end

    local keys = vim.api.nvim_replace_termcodes('<Plug>(DBUI_ExecuteQuery)', true, false, true)
    vim.api.nvim_feedkeys(keys, 'm', false)
    return true
end

local function run_query()
    if execute_dbui_query('n') then
        return
    end

    run_all()
end

local function run_visual_query()
    if execute_dbui_query('x') then
        return
    end

    run_selection()
end

local function load_dbui()
    local ok, lazy = pcall(require, 'lazy')
    if ok then
        lazy.load({ plugins = { 'vim-dadbod-ui' } })
    end
end

local function dbui_key_name(connection)
    if connection.key_name ~= nil and connection.key_name ~= '' then
        return connection.key_name
    end

    if connection.name == nil or connection.source == nil then
        return nil
    end

    return connection.name .. '_' .. connection.source
end

local function set_buffer_connection(connection)
    local key_name = dbui_key_name(connection)

    vim.b.db = connection.url
    vim.b.db_url = connection.url
    vim.b.db_name = connection.name
    vim.b.db_source = connection.source

    if key_name ~= nil then
        vim.b.dbui_db_key_name = key_name
    end
end

local function get_buffer_connection()
    local url = vim.b.db_url or vim.b.db
    if url == nil and vim.b.dbui_db_key_name ~= nil then
        load_dbui()
        local conn_info = vim.fn['db_ui#get_conn_info'](vim.b.dbui_db_key_name)
        if conn_info ~= nil and conn_info.url ~= nil and conn_info.url ~= '' then
            url = conn_info.url
        end
    end

    if url == nil then
        return nil
    end

    return {
        url = url,
        name = vim.b.db_name or vim.b.dbui_db_key_name or 'db',
        source = vim.b.db_source,
        key_name = vim.b.dbui_db_key_name,
    }
end

local function sql_template_find_command()
    local globs = { '*.sql', '*.psql', '*.pgsql', '*.mysql', '*.plsql' }

    if vim.fn.executable('rg') == 1 then
        local command = { 'rg', '--files', '--color', 'never' }
        for _, glob in ipairs(globs) do
            vim.list_extend(command, { '--glob', glob })
        end
        return command
    end

    if vim.fn.executable('fd') == 1 then
        return { 'fd', '--type', 'f', '--extension', 'sql', '--extension', 'psql', '--extension', 'pgsql', '--extension', 'mysql', '--extension', 'plsql', '--color', 'never' }
    end

    return nil
end

local function project_root()
    local git_root = vim.fs.root(0, '.git')
    if git_root ~= nil then
        return git_root
    end

    git_root = vim.fs.root(vim.fn.getcwd(), '.git')
    if git_root ~= nil then
        return git_root
    end

    return vim.fn.getcwd()
end

local function open_template_copy_file(source)
    local connection = get_buffer_connection()
    if connection == nil or connection.key_name == nil then
        vim.notify('Choose DB connection first with <leader>fd', vim.log.levels.WARN)
        return
    end

    local lines = vim.fn.readfile(source)
    local run_dir = vim.g.db_ui_tmp_query_location
    vim.fn.mkdir(run_dir, 'p')

    local name = vim.fn.fnamemodify(source, ':t:r')
    local target = string.format('%s/%s-%s.sql', run_dir, name, os.date('%Y%m%d-%H%M%S'))
    vim.fn.writefile(lines, target)

    vim.cmd.edit(vim.fn.fnameescape(target))
    vim.bo.filetype = 'sql'
    vim.b.sql_template_source = source
    set_buffer_connection(connection)

    load_dbui()
    local conn_info = vim.fn['db_ui#get_conn_info'](connection.key_name)
    if conn_info ~= nil and conn_info.conn ~= nil and conn_info.conn ~= '' then
        vim.b.db = conn_info.conn
    end

    vim.cmd.DBUIFindBuffer()

    vim.notify('SQL template copy: ' .. vim.fn.fnamemodify(source, ':~:.'), vim.log.levels.INFO)
end

local function open_template_copy()
    local roots = {}
    local seen = {}
    for _, root in ipairs({ project_root(), vim.fn.expand('~/dev/sql') }) do
        root = vim.fs.normalize(root)
        if vim.fn.isdirectory(root) == 1 and not seen[root] then
            table.insert(roots, root)
            seen[root] = true
        end
    end

    if vim.tbl_isempty(roots) then
        vim.notify('No SQL query search roots found', vim.log.levels.WARN)
        return
    end

    local command = sql_template_find_command()
    if command == nil then
        vim.notify('SQL query picker needs rg or fd', vim.log.levels.ERROR)
        return
    end
    vim.list_extend(command, roots)

    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    pickers.new({}, {
        prompt_title = 'SQL queries',
        finder = finders.new_oneshot_job(command, {
            entry_maker = function(path)
                local absolute = vim.fn.fnamemodify(path, ':p')

                return {
                    value = absolute,
                    filename = absolute,
                    path = absolute,
                    display = vim.fn.fnamemodify(absolute, ':~:.'),
                    ordinal = absolute,
                }
            end,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.file_sorter({}),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)

                if selection == nil then
                    return
                end

                local path = selection.path or selection.filename or selection.value or selection[1]
                if path == nil then
                    return
                end

                local ok, err = pcall(open_template_copy_file, path)
                if not ok then
                    vim.notify('Failed to open SQL template copy: ' .. err, vim.log.levels.ERROR)
                end
            end)

            return true
        end,
    }):find()
end

local function choose_connection()
    load_dbui()

    local connections = vim.fn['db_ui#connections_list']()
    if vim.tbl_isempty(connections) then
        vim.notify('No DBUI connections found', vim.log.levels.WARN)
        return
    end

    table.sort(connections, function(a, b)
        return string.lower(a.name) < string.lower(b.name)
    end)

    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    pickers.new({}, {
        prompt_title = 'DB connections',
        finder = finders.new_table({
            results = connections,
            entry_maker = function(connection)
                local source = connection.source
                if source == nil or source == '' then
                    source = 'unknown'
                end

                return {
                    value = connection,
                    display = string.format('%s (%s)', connection.name, source),
                    ordinal = connection.name .. ' ' .. source,
                }
            end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)

                if selection == nil then
                    return
                end

                set_buffer_connection(selection.value)

                if vim.fn.exists('*vim_dadbod_completion#fetch') == 1 then
                    vim.fn['vim_dadbod_completion#fetch'](vim.api.nvim_get_current_buf())
                end

                vim.notify('DB: ' .. selection.value.name, vim.log.levels.INFO)
            end)

            return true
        end,
    }):find()
end

vim.keymap.set('n', '<leader>ed', '<cmd>DBUIToggle<CR>', { desc = 'Toggle DB UI' })
vim.keymap.set('n', '<leader>fd', choose_connection, { desc = 'Find DB connection' })
vim.keymap.set('n', '<leader>fq', open_template_copy, { desc = 'Find SQL query' })
vim.keymap.set('x', '<leader>rq', run_visual_query, { desc = 'Run SQL query selection' })

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'sql', 'mysql', 'plsql', 'psql', 'pgsql' },
    callback = function(event)
        local opts = { buffer = event.buf }
        vim.keymap.set('n', '<leader>rr', run_query, vim.tbl_extend('force', opts, { desc = 'Run SQL query' }))
        vim.keymap.set('n', '<leader>ra', '<cmd>%DB<CR>', vim.tbl_extend('force', opts, { desc = 'Run SQL buffer' }))
    end,
})
