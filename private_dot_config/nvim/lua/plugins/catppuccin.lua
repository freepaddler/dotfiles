require('catppuccin').setup({
    flavour = 'macchiato',
    transparent_background = true,
    custom_highlights = function(colors)
        return {
            StatusLine = { fg = colors.text, bg = colors.mantle },
            StatusLineNC = { fg = colors.overlay0, bg = colors.mantle },
            WinSeparator = { fg = colors.surface2 },
            VertSplit = { fg = colors.surface2 },
        }
    end,
    styles = {
        conditionals = {},
    },
    auto_integrations = true,
})
