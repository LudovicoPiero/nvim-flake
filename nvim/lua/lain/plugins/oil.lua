local oil = require("oil")

oil.setup({
  view_options = { show_hidden = true },
  default_file_explorer = true,
  columns = {
    "permissions",
    "mtime",
    "size",
    "icon",
  },
})

local map = vim.keymap.set
map("n", "<leader>tf", "<CMD>Oil<CR>", { desc = "[T]oggle [F]ile Explorer", silent = true })
