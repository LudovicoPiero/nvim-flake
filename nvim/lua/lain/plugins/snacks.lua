local snacks = require("snacks")

snacks.setup({
  -- UI
  scroll = { enabled = false },
  bigfile = { enabled = true },
  image = { doc = { enabled = false } },
  input = { enabled = true },

  notifier = {
    enabled = true,
    timeout = 3000,
  },

  picker = { ui_select = true },

  -- Buffer and indent settings.
  bufdelete = { enabled = true },
  indent = {
    enabled = true,
    indent = { char = "▏" },
    scope = { char = "▏" },
    animate = { enabled = false },
  },

  dashboard = {
    enabled = true,
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      { section = "projects", gap = 0.5, padding = 0.5 },
      { section = "recent_files", gap = 0.5, padding = 0.5 },
    },
    preset = {
      header = [[
        ███╗   ██╗██╗██╗  ██╗ ██████╗ ███████╗
        ████╗  ██║██║╚██╗██╔╝██╔═══██╗██╔════╝
        ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║███████╗
        ██║╚██╗██║██║ ██╔██╗ ██║   ██║╚════██║
        ██║ ╚████║██║██╔╝ ██╗╚██████╔╝███████║
        ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
      ]],
    },
  },
})

local map = vim.keymap.set

map("n", "<leader>bd", function()
  snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("n", "<leader>rf", function()
  snacks.rename.rename_file()
end, { desc = "Rename File" })
map("n", "<leader>gl", function()
  snacks.lazygit()
end, { desc = "LazyGit" })

map("n", "<leader>sf", function()
  snacks.picker.files({ matcher = { frecency = true, history_bonus = true, ignorecase = false } })
end, { desc = "Search Files" })

map("n", "<leader>s.", function()
  snacks.picker.recent()
end, { desc = "Recent Files" })
map("n", "<leader><leader>", function()
  snacks.picker.buffers()
end, { desc = "Open Buffers" })

map("n", "<leader>sg", function()
  snacks.picker.grep()
end, { desc = "Live Grep" })
map({ "n", "x" }, "<leader>sw", function()
  snacks.picker.grep_word()
end, { desc = "Grep Current Word" })
map("n", "<leader>/", function()
  snacks.picker.lines()
end, { desc = "Grep Buffer" })

map("n", "<leader>sd", function()
  snacks.picker.diagnostics_buffer()
end, { desc = "Document Diagnostics" })
map("n", "<leader>sD", function()
  snacks.picker.diagnostics()
end, { desc = "Workspace Diagnostics" })
map("n", "<leader>sq", function()
  snacks.picker.qflist()
end, { desc = "Quickfix List" })

map("n", "<leader>sb", function()
  snacks.picker.pickers()
end, { desc = "Snacks Pickers" })
map("n", "<leader>sh", function()
  snacks.picker.help()
end, { desc = "Search Help" })
map("n", "<leader>sk", function()
  snacks.picker.keymaps()
end, { desc = "Search Keymaps" })
