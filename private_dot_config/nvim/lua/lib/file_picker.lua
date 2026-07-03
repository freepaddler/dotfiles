local M = {}

local function normalize_roots(roots)
    local result = {}
    local seen = {}

    for _, root in ipairs(roots or {}) do
        root = vim.fn.expand(root)
        root = vim.fn.fnamemodify(root, ':p')
        root = vim.fs.normalize(root)

        if vim.fn.isdirectory(root) == 1 and not seen[root] then
            table.insert(result, root)
            seen[root] = true
        end
    end

    return result
end

local function extension_globs(extensions)
    local globs = {}

    for _, extension in ipairs(extensions or {}) do
        extension = extension:gsub('^%.', '')
        table.insert(globs, '*.' .. extension)
    end

    return globs
end

local function file_globs(opts)
    local globs = {}

    vim.list_extend(globs, extension_globs(opts.extensions))
    vim.list_extend(globs, opts.globs or {})

    return globs
end

local function find_command(opts, roots)
    local globs = file_globs(opts)

    if vim.fn.executable('rg') == 1 then
        local command = { 'rg', '--files', '--color', 'never' }

        if opts.hidden then
            table.insert(command, '--hidden')
        end

        for _, glob in ipairs(globs) do
            vim.list_extend(command, { '--glob', glob })
        end

        vim.list_extend(command, roots)
        return command
    end

    if vim.fn.executable('fd') == 1 then
        local command = { 'fd', '--type', 'f', '--color', 'never' }

        if opts.hidden then
            table.insert(command, '--hidden')
        end

        if opts.extensions ~= nil then
            for _, extension in ipairs(opts.extensions) do
                extension = extension:gsub('^%.', '')
                vim.list_extend(command, { '--extension', extension })
            end
        end

        for _, glob in ipairs(opts.globs or {}) do
            vim.list_extend(command, { '--glob', glob })
        end

        vim.list_extend(command, { '.', unpack(roots) })
        return command
    end

    return nil
end

local function selected_path(selection)
    if selection == nil then
        return nil
    end

    return selection.path or selection.filename or selection.value or selection[1]
end

function M.files(opts)
    opts = opts or {}

    local roots = normalize_roots(opts.roots)
    if vim.tbl_isempty(roots) then
        vim.notify((opts.empty_roots_message or 'No file picker roots found'), vim.log.levels.WARN)
        return
    end

    local command = find_command(opts, roots)
    if command == nil then
        vim.notify((opts.missing_tool_message or 'File picker needs rg or fd'), vim.log.levels.ERROR)
        return
    end

    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    pickers.new(opts.picker_opts or {}, {
        prompt_title = opts.title or 'Files',
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
        previewer = opts.previewer or conf.file_previewer({}),
        sorter = opts.sorter or conf.file_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            if opts.on_select ~= nil then
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    local path = selected_path(selection)
                    actions.close(prompt_bufnr)

                    if path == nil then
                        return
                    end

                    local ok, err = pcall(opts.on_select, path, {
                        selection = selection,
                        roots = roots,
                        prompt_bufnr = prompt_bufnr,
                    })
                    if not ok then
                        vim.notify((opts.error_prefix or 'File picker action failed: ') .. err, vim.log.levels.ERROR)
                    end
                end)
            end

            if opts.attach_mappings ~= nil then
                return opts.attach_mappings(prompt_bufnr, map, {
                    roots = roots,
                    selected_path = selected_path,
                })
            end

            return true
        end,
    }):find()
end

function M.grep(opts)
    opts = opts or {}

    local roots = normalize_roots(opts.roots)
    if vim.tbl_isempty(roots) then
        vim.notify((opts.empty_roots_message or 'No grep roots found'), vim.log.levels.WARN)
        return
    end

    local glob_pattern = file_globs(opts)
    if vim.tbl_isempty(glob_pattern) then
        glob_pattern = nil
    end

    require('telescope.builtin').live_grep(vim.tbl_extend('force', opts.picker_opts or {}, {
        prompt_title = opts.title or 'Grep',
        search_dirs = roots,
        glob_pattern = glob_pattern,
    }))
end

return M
