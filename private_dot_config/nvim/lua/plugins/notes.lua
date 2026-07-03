local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local file_picker = require('lib.file_picker')

local notes_dir = vim.fs.normalize(vim.fn.fnamemodify(vim.fn.expand('~/Dropbox/Notes'), ':p'))
local scratch_dirname = '.scratch'
local default_ext = 'txt'
local fd_excludes = { '.git', 'node_modules', 'vendor', 'dist', 'build', 'target', '.cache' }

local last_popup_path = nil
local popup_win = nil
local popup_buf = nil
local popup_map_keys = {
    n = { 'q', '<C-b>', '<C-v>', '<C-h>', '<C-t>', '<C-a>', '<C-s>' },
    i = { '<C-l>', '<C-a>', '<C-s>' },
}

math.randomseed(os.time() + tonumber(tostring(vim.uv.hrtime()):sub(-6)))

local function notify(message, level)
    vim.notify(message, level or vim.log.levels.INFO)
end

local function normalize(path)
    return vim.fs.normalize(vim.fn.fnamemodify(vim.fn.expand(path), ':p'))
end

local function path_with_sep(path)
    return path:sub(-1) == '/' and path or path .. '/'
end

local function is_inside(root, path)
    root = vim.fs.normalize(root)
    path = vim.fs.normalize(path)
    return path == root or vim.startswith(path, path_with_sep(root))
end

local function relpath(root, path)
    root = path_with_sep(vim.fs.normalize(root))
    path = vim.fs.normalize(path)

    if vim.startswith(path, root) then
        return path:sub(#root + 1)
    end

    return path
end

local function cwd()
    return normalize(vim.fn.getcwd())
end

local function scratch_create_root()
    return vim.fs.joinpath(cwd(), scratch_dirname)
end

local function dedupe(list)
    local result = {}
    local seen = {}

    for _, item in ipairs(list) do
        item = vim.fs.normalize(item)
        if item ~= '' and not seen[item] then
            table.insert(result, item)
            seen[item] = true
        end
    end

    return result
end

local function scratch_roots()
    if vim.fn.executable('fd') ~= 1 then
        notify('Notes scratch discovery needs fd', vim.log.levels.ERROR)
        return nil
    end

    local command = { 'fd', '--type', 'd', '--hidden', '--color', 'never' }
    for _, exclude in ipairs(fd_excludes) do
        vim.list_extend(command, { '--exclude', exclude })
    end
    vim.list_extend(command, { '^\\.scratch$', cwd() })

    local roots = {}
    if vim.fn.isdirectory(scratch_create_root()) == 1 then
        table.insert(roots, scratch_create_root())
    end

    local found = vim.fn.systemlist(command)
    if vim.v.shell_error ~= 0 then
        notify('Failed to discover scratch directories with fd', vim.log.levels.ERROR)
        return nil
    end

    for _, root in ipairs(found) do
        if root ~= '' and vim.fn.isdirectory(root) == 1 then
            table.insert(roots, normalize(root))
        end
    end

    table.sort(roots)
    return dedupe(roots)
end

local function roots()
    local result = {}

    if vim.fn.isdirectory(notes_dir) == 1 then
        table.insert(result, notes_dir)
    end

    local scratches = scratch_roots()
    if scratches == nil then
        return nil
    end

    for _, root in ipairs(scratches) do
        table.insert(result, root)
    end

    return result
end

local function is_note_path(path)
    path = normalize(path)
    return is_inside(notes_dir, path)
end

local function is_scratch_path(path)
    path = normalize(path)
    local current = cwd()
    local marker = '/' .. scratch_dirname .. '/'
    return path:find(marker, 1, true) ~= nil and is_inside(current, path)
end

local function is_managed_path(path)
    return is_note_path(path) or is_scratch_path(path)
end

local function popup_title(path)
    if is_note_path(path) then
        return relpath(notes_dir, path)
    end

    if is_scratch_path(path) then
        return relpath(cwd(), path)
    end

    return vim.fn.fnamemodify(path, ':t')
end

local function selected_path()
    local selection = action_state.get_selected_entry()
    if selection == nil then
        return nil
    end

    return selection.path or selection.filename or selection.value or selection[1]
end

local function add_default_ext(path)
    if vim.fn.fnamemodify(path, ':e') ~= '' then
        return path
    end

    return path .. '.' .. default_ext
end

local function sanitize_relative_path(input)
    input = vim.trim(input or '')
    input = input:gsub('^[/\\]+', '')

    if input == '' then
        return nil
    end

    return add_default_ext(input)
end

local function default_name()
    return string.format('untitled_%s_%04x.%s', os.date('%Y%m%d'), math.random(0, 0xffff), default_ext)
end

local function target_path(root, input)
    local relative = sanitize_relative_path(input)
    if relative == nil then
        relative = default_name()
    end

    local target = vim.fs.normalize(vim.fs.joinpath(root, relative))
    if not is_inside(root, target) then
        notify('Path escapes notes root: ' .. relative, vim.log.levels.ERROR)
        return nil
    end

    return target
end

local function unique_default_path(root)
    for _ = 1, 100 do
        local target = target_path(root, '')
        if target ~= nil and vim.fn.filereadable(target) == 0 then
            return target
        end
    end

    notify('Failed to generate a unique note name', vim.log.levels.ERROR)
    return nil
end

local function create_file(root, input)
    vim.fn.mkdir(root, 'p')

    local target = nil
    if input == nil or vim.trim(input) == '' then
        target = unique_default_path(root)
    else
        target = target_path(root, input)
    end

    if target == nil then
        return nil
    end

    if vim.fn.filereadable(target) == 1 or vim.fn.isdirectory(target) == 1 then
        notify('File already exists: ' .. vim.fn.fnamemodify(target, ':~:.'), vim.log.levels.ERROR)
        return nil
    end

    vim.fn.mkdir(vim.fn.fnamemodify(target, ':h'), 'p')
    local ok, err = pcall(vim.fn.writefile, {}, target)
    if not ok then
        notify('Failed to create file: ' .. err, vim.log.levels.ERROR)
        return nil
    end

    return target
end

local set_last_and_open

local function edit_file(path)
    vim.cmd.edit(vim.fn.fnameescape(path))
end

local function prompt_input(title, callback)
    local ok, popup = pcall(require, 'plenary.popup')
    if not ok then
        vim.ui.input({ prompt = title .. ': ' }, callback)
        return
    end

    local buffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buffer, 0, -1, false, { '' })
    vim.bo[buffer].bufhidden = 'wipe'

    local width = math.min(60, math.max(30, math.floor(vim.o.columns * 0.5)))
    local win = popup.create(buffer, {
        title = title,
        border = true,
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        minwidth = width,
        minheight = 1,
        line = math.floor((vim.o.lines - 3) / 2),
        col = math.floor((vim.o.columns - width) / 2),
    })

    local done = false
    local function close()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end

    local function submit()
        if done then
            return
        end
        done = true

        local input = vim.api.nvim_buf_get_lines(buffer, 0, 1, false)[1] or ''
        close()
        callback(input)
    end

    local function cancel()
        if done then
            return
        end
        done = true

        close()
        callback(nil)
    end

    local opts = { buffer = buffer, nowait = true, silent = true }
    vim.keymap.set({ 'i', 'n' }, '<CR>', submit, opts)
    vim.keymap.set({ 'i', 'n' }, '<Esc>', cancel, opts)
    vim.keymap.set('i', '<C-c>', cancel, opts)
    vim.keymap.set('n', 'q', cancel, opts)

    vim.api.nvim_set_current_win(win)
    vim.schedule(function()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_set_current_win(win)
            vim.cmd.startinsert()
        end
    end)
end

local function prompt_create(root, title)
    prompt_input(title, function(input)
        if input == nil then
            return
        end

        local path = create_file(root, input)
        if path ~= nil then
            set_last_and_open(path)
        end
    end)
end

local function create_note()
    prompt_create(notes_dir, 'New Note')
end

local function create_scratch()
    prompt_create(scratch_create_root(), 'New Scratch')
end

local function popup_is_open()
    return popup_win ~= nil and vim.api.nvim_win_is_valid(popup_win)
end

local function save_popup()
    if popup_buf == nil or not vim.api.nvim_buf_is_valid(popup_buf) then
        return
    end

    if vim.bo[popup_buf].modified then
        vim.api.nvim_buf_call(popup_buf, function()
            vim.cmd.write()
        end)
    end
end

local function close_popup(save)
    if save ~= false then
        save_popup()
    end

    if popup_buf ~= nil and vim.api.nvim_buf_is_valid(popup_buf) then
        for mode, keys in pairs(popup_map_keys) do
            for _, key in ipairs(keys) do
                pcall(vim.keymap.del, mode, key, { buffer = popup_buf })
            end
        end
    end

    if popup_is_open() then
        vim.api.nvim_win_close(popup_win, true)
    end

    popup_win = nil
    popup_buf = nil
end

local function open_file(path, command)
    vim.cmd(command .. ' ' .. vim.fn.fnameescape(path))
end

local function promote_popup(command)
    if popup_buf == nil or not vim.api.nvim_buf_is_valid(popup_buf) then
        return
    end

    local path = vim.api.nvim_buf_get_name(popup_buf)
    if path == '' then
        return
    end

    close_popup(true)
    open_file(path, command)
end

local function popup_opts(path)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)

    return {
        relative = 'editor',
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2),
        border = 'rounded',
        title = popup_title(path),
        title_pos = 'center',
        style = 'minimal',
    }
end

local function open_popup(path)
    path = normalize(path)

    if popup_is_open() and vim.api.nvim_buf_get_name(popup_buf) == path then
        vim.api.nvim_set_current_win(popup_win)
        return
    end

    if popup_is_open() then
        close_popup(true)
    end

    local buffer = vim.fn.bufadd(path)
    vim.fn.bufload(buffer)

    popup_buf = buffer
    popup_win = vim.api.nvim_open_win(buffer, true, popup_opts(path))
    vim.wo[popup_win].wrap = true
    vim.wo[popup_win].number = true
    vim.wo[popup_win].relativenumber = false
    vim.wo[popup_win].signcolumn = 'yes'

    local opts = { buffer = buffer, nowait = true, silent = true }
    vim.keymap.set('n', 'q', function()
        close_popup(true)
    end, opts)
    vim.keymap.set('i', '<C-l>', function()
        close_popup(true)
    end, opts)
    vim.keymap.set('n', '<C-b>', function()
        promote_popup('edit')
    end, opts)
    vim.keymap.set('n', '<C-v>', function()
        promote_popup('vsplit')
    end, opts)
    vim.keymap.set('n', '<C-h>', function()
        promote_popup('split')
    end, opts)
    vim.keymap.set('n', '<C-t>', function()
        promote_popup('tabedit')
    end, opts)
    vim.keymap.set({ 'n', 'i' }, '<C-a>', create_note, opts)
    vim.keymap.set({ 'n', 'i' }, '<C-s>', create_scratch, opts)
end

set_last_and_open = function(path)
    last_popup_path = normalize(path)
    open_popup(last_popup_path)
end

local function toggle_last_popup()
    if popup_is_open() then
        close_popup(true)
        return
    end

    if last_popup_path == nil or vim.fn.filereadable(last_popup_path) == 0 then
        local path = create_file(notes_dir, '')
        if path == nil then
            return
        end
        last_popup_path = path
    end

    open_popup(last_popup_path)
end

local function delete_file(path)
    path = normalize(path)
    if not is_managed_path(path) then
        notify('Refusing to delete outside notes roots: ' .. vim.fn.fnamemodify(path, ':~:.'), vim.log.levels.ERROR)
        return
    end

    local label = vim.fn.fnamemodify(path, ':~:.')

    if vim.fn.confirm('Delete ' .. label .. '?', '&Yes\n&No', 2) ~= 1 then
        return
    end

    if popup_is_open() and vim.api.nvim_buf_get_name(popup_buf) == path then
        close_popup(true)
    end

    local buffer = vim.fn.bufnr(path)
    if buffer ~= -1 and vim.api.nvim_buf_is_loaded(buffer) and vim.bo[buffer].modified then
        vim.api.nvim_buf_call(buffer, function()
            vim.cmd.write()
        end)
    end

    local ok, err = pcall(vim.fn.delete, path)
    if not ok or err ~= 0 then
        notify('Failed to delete file: ' .. label, vim.log.levels.ERROR)
        return
    end

    if buffer ~= -1 and vim.api.nvim_buf_is_valid(buffer) then
        pcall(vim.api.nvim_buf_delete, buffer, { force = true })
    end

    if last_popup_path == path then
        last_popup_path = nil
    end

    notify('Deleted ' .. label)
end

local function attach_common_mappings(prompt_bufnr, map, helper)
    local function current_path()
        local path = helper ~= nil and helper.selected_path() or selected_path()
        if path == nil then
            notify('No file selected', vim.log.levels.WARN)
        end
        return path
    end

    local function close_and_create_note()
        actions.close(prompt_bufnr)
        create_note()
    end

    local function close_and_create_scratch()
        actions.close(prompt_bufnr)
        create_scratch()
    end

    local function close_and_popup()
        local path = current_path()
        if path == nil then
            return
        end

        actions.close(prompt_bufnr)
        set_last_and_open(path)
    end

    local function close_and_edit()
        local path = current_path()
        if path == nil then
            return
        end

        actions.close(prompt_bufnr)
        edit_file(path)
    end

    local function close_and_delete()
        local path = current_path()
        if path == nil then
            return
        end

        actions.close(prompt_bufnr)
        delete_file(path)
    end

    actions.select_default:replace(close_and_popup)

    map('i', '<C-a>', close_and_create_note)
    map('n', '<C-a>', close_and_create_note)
    map('i', '<C-s>', close_and_create_scratch)
    map('n', '<C-s>', close_and_create_scratch)
    map('i', '<C-l>', close_and_popup)
    map('n', '<C-l>', close_and_popup)
    map('i', '<C-b>', close_and_edit)
    map('n', '<C-b>', close_and_edit)
    map('i', '<C-x>', close_and_delete)
    map('n', '<C-x>', close_and_delete)

    return true
end

local function files()
    local root_list = roots()
    if root_list == nil then
        return
    end

    file_picker.files({
        title = 'Notes',
        roots = root_list,
        hidden = true,
        empty_roots_message = 'No notes or scratch directories found',
        attach_mappings = attach_common_mappings,
    })
end

local function grep()
    local root_list = roots()
    if root_list == nil then
        return
    end

    if vim.tbl_isempty(root_list) then
        notify('No notes or scratch directories found', vim.log.levels.WARN)
        return
    end

    require('telescope.builtin').live_grep({
        prompt_title = 'Notes grep',
        search_dirs = root_list,
        additional_args = function()
            return { '--hidden' }
        end,
        attach_mappings = attach_common_mappings,
    })
end

vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = save_popup,
})

vim.keymap.set('n', '<leader>fn', files, { desc = 'Find notes and scratches' })
vim.keymap.set('n', '<leader>sn', grep, { desc = 'Search notes and scratches' })
vim.keymap.set('n', '<C-l>', toggle_last_popup, { desc = 'Toggle last note popup' })
