-- store save time on each write
vim.api.nvim_create_autocmd('BufWritePost', {
    callback = function()
        vim.b.file_saved_time = os.time()
    end
})

local function relModTime()
    local saved = vim.b.file_saved_time
    if not saved then
        return ''
    end

    local diff = os.time() - saved
    if diff <= 0 then
        return ''
    end

    local h = math.floor(diff / 3600)
    local m = math.floor((diff % 3600) / 60)
    local s = diff % 60

    if h > 0 then
        return string.format('%dh%dm ago', h, m)
    elseif m > 0 then
        return string.format('%dm ago', m)
    else
        return string.format('%ds ago', s)
    end
end

local filenamt_shorting_target = 60

local function dbNameFromPath(path)
    if path == nil or path == '' then
        return nil
    end

    local name = path:match('/([^/?#]+)$')
    if name == nil or name == '' then
        return nil
    end

    return vim.fn['db#url#decode'](name)
end

local function dbConnection()
    if vim.b.db_name ~= nil and vim.b.db_name ~= '' then
        return 'DB ' .. vim.b.db_name
    end

    local db = vim.b.db_url or vim.b.db or vim.g.db
    if db == nil or type(db) ~= 'string' then
        return ''
    end

    local ok, parsed = pcall(vim.fn['db#url#parse'], db)
    if not ok or type(parsed) ~= 'table' then
        return ''
    end

    local database = dbNameFromPath(parsed.path)
    local host = parsed.host
    if host == nil or host == '' then
        return database ~= nil and ('DB ' .. database) or ''
    end

    if not host:find(':', 1, true) then
        host = host:match('^[^.]+') or host
    end

    local label = host
    if parsed.user ~= nil and parsed.user ~= '' then
        label = parsed.user .. '@' .. label
    end

    if parsed.port ~= nil and parsed.port ~= '' then
        label = label .. ':' .. parsed.port
    end

    if database ~= nil then
        label = label .. '/' .. database
    end

    return 'DB ' .. label
end

require('lualine').setup({
    options = {
        theme = 'auto',
        icons_enabled = false,
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
    },
    extensions = { 'lazy' },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { { 'branch', icons_enabled = true } },
        lualine_c = {
            { 'filename', path = 3, shorting_target = filenamt_shorting_target },
            relModTime,
        },
        lualine_x = { dbConnection, 'diagnostics', 'fileformat', 'encoding', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
            { 'filename', path = 3, shorting_target = filenamt_shorting_target },
            relModTime
        },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {
        lualine_a = {
            {
                'tabs',
                max_length = vim.o.columns,
                mode = 2,
                path = 0,
                show_modified_status = false,

                fmt = function(name, context)
                    -- Show + if buffer is modified in tab
                    local buflist = vim.fn.tabpagebuflist(context.tabnr)
                    local winnr = vim.fn.tabpagewinnr(context.tabnr)
                    local bufnr = buflist[winnr]
                    local mod = vim.fn.getbufvar(bufnr, '&mod')

                    return name .. (mod == 1 and ' +' or '')
                end
            }
        }
    }
})

vim.opt.showmode = false
