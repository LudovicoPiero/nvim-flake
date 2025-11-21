local opt = vim.opt

-- === UI & Display ===
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.showmode = false
opt.scrolloff = 10
opt.colorcolumn = "80,100"
opt.laststatus = 3

-- Sets default border for all floating windows (LSP, diagnostic, etc.)
opt.winborder = "rounded"

-- === Modern Neovim Features ===
opt.smoothscroll = true
opt.splitkeep = "screen"

-- === Cursor & Input ===
opt.mouse = "a"
opt.guicursor = "n-v-i-c:block-Cursor"
opt.timeoutlen = 300

-- === Indentation ===
opt.expandtab = true
opt.smartindent = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.breakindent = true

-- === Search ===
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.inccommand = "split"

-- === Splits ===
opt.splitbelow = true
opt.splitright = true

-- === File & Undo ===
opt.undofile = true
opt.swapfile = false
opt.updatetime = 250
opt.exrc = true -- Allow local .nvim.lua files

-- === Clipboard ===
opt.clipboard = "unnamedplus"

-- === Visuals ===
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
