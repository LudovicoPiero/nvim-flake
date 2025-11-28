local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.showmode = false
opt.scrolloff = 10
opt.colorcolumn = "80,100"
opt.laststatus = 3
-- Default border for floats.
opt.winborder = "rounded"

-- Modern features.
opt.smoothscroll = true
opt.splitkeep = "screen"

-- Cursor and input.
opt.mouse = "a"
opt.guicursor = "n-v-i-c:block-Cursor"
opt.timeoutlen = 300

-- Indentation.
opt.expandtab = true
opt.smartindent = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.breakindent = true

-- Search.
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.inccommand = "split"

-- Splits.
opt.splitbelow = true
opt.splitright = true

-- File and undo.
opt.undofile = true
opt.swapfile = false
opt.updatetime = 250
opt.exrc = true -- Allow local .nvim.lua files

-- Clipboard.
opt.clipboard = "unnamedplus"

-- Visual characters.
opt.fillchars = {
  eob = " ",
  vert = "│",
  fold = " ",
  diff = "╱",
}

opt.list = true
opt.listchars = {
  tab = "  ",
  trail = "·",
  extends = "›",
  precedes = "‹",
  nbsp = "␣",
}
