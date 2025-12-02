-- store save time on each write
vim.api.nvim_create_autocmd("BufWritePost", {
    callback = function()
        vim.b.file_saved_time = os.time()
    end
})

local function relModTime()
    local saved = vim.b.file_saved_time
    if not saved then
        return ""
    end

    local diff = os.time() - saved
    if diff <= 0 then
        return ""
    end

    local h = math.floor(diff / 3600)
    local m = math.floor((diff % 3600) / 60)
    local s = diff % 60

    if h > 0 then
        return string.format("%dh%dm ago", h, m)
    elseif m > 0 then
        return string.format("%dm ago", m)
    else
        return string.format("%ds ago", s)
    end
end

require('lualine').setup({
    options = {
        theme = 'auto',
        icons_enabled = false,
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
    },
    extensions = {'lazy'},
    sections = {
        lualine_a = {'mode'},
        lualine_b = {{'branch',icons_enabled = true},'diagnostics'},
        lualine_c = {
            { 'filename', path = 3, shorting_target = vim.o.columns - 60 },
            relModTime, 
        },
        lualine_x = {'fileformat','encoding','filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'},
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
