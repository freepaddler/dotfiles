vim.opt.fileencodings = {
    'ucs-bom', 'utf-8', 'default',
    'cp1251', 'koi8-r', 'cp866',
    'latin1',
}

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath('state') .. '/undo'
vim.opt.undofile = true

vim.opt.isfname:append('@-@') -- treat @ as filename
vim.opt.autoread = true       -- reload on external change if no local changes

vim.opt.updatetime = 200      -- be more responsive (default 4000ms)

vim.opt.timeoutlen = 2000

vim.opt.termguicolors = true
vim.opt.guicursor = '' -- avoid cursor mutations
vim.opt.winborder = 'rounded'

vim.opt.wrap = true

-- tabs and alignment
vim.opt.tabstop = 4        -- spaces a <Tab> shows as
vim.opt.softtabstop = 4    -- spaces a <Tab> counts as when editing
vim.opt.shiftwidth = 4     -- spaces for << and >>
vim.opt.smarttab = true    -- smarter tab behavior at line start
vim.opt.expandtab = true   -- insert spaces instead of <Tab>

vim.opt.smartindent = true -- reverse indent closing bracket

-- line numbers
vim.opt.cursorline = true     -- higlight current line
vim.opt.number = true         -- line numbering
vim.opt.relativenumber = true -- relative numbers
vim.opt.colorcolumn = '81'    -- higlight column 81
vim.opt.signcolumn = 'yes'    -- always who sign column

-- search
vim.opt.hlsearch = true     -- last search
vim.opt.incsearch = true    -- incremental
vim.opt.ignorecase = true   -- case insensitive
vim.opt.smartcase = true    -- case sensitive if uppercase input

vim.opt.showmatch = true    -- briefly jump to matching bracket
vim.opt.startofline = false -- don't jump to column 0 on some motions
vim.opt.scrolloff = 6       -- keep N lines visible above/below cursor

-- split
vim.opt.splitright = true -- vsplit always right
vim.opt.splitbelow = true -- split always down

-- docs window size
vim.g.ui_docs_max_width = 120
vim.g.ui_docs_max_height = 40
