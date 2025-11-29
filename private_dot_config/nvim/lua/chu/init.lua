require('chu.settings')
require('chu.keymap')
require('chu.lazy')

vim.cmd.colorscheme 'nord'
--vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- higlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({
      higroup = "Search",
      timeout = 200,
    })
  end,
})

