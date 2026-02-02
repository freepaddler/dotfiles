vim.keymap.set("n", "<leader>tf", ":Neotree filesystem reveal left<CR>", {})
vim.keymap.set("n", "<leader>tb", ":Neotree buffers reveal float<CR>", {})

require("neo-tree").setup({
  filesystem = {
    hijack_netrw_behavior = "disabled",
  },
})
