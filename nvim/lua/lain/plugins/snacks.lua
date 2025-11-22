---@diagnostic disable: undefined-global
local snacks = require("snacks")

snacks.setup({
  -- Disable the smooth scrolling animation
  scroll = { enabled = false },

  -- Handling for large files
  bigfile = { enabled = true },

  -- Configure image support
  image = { doc = { enabled = false } },

  -- Replaces Fidget (Notifications)
  notifier = {
    enabled = true,
    timeout = 3000,
  },

  -- Configure Picker and `vim.ui.select`
  picker = { ui_select = true },
  -- Replaces mini.bufremove (Smart buffer delete)
  bufdelete = { enabled = true },

  -- Replaces indent-blankline (Indent guides)
  indent = {
    enabled = true,
    indent = { char = "▏" },
    scope = { char = "▏" },
    animate = { enabled = false },
  },

  -- Nice input UI for renaming
  input = { enabled = true },

  -- Start screen
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

-- Keymaps
local map = vim.keymap.set

-- Buffer Delete (Replaces mini.bufremove)
map("n", "<leader>bd", function()
  snacks.bufdelete()
end, { desc = "Delete Buffer" })

-- Rename File (Smart rename that updates LSP imports)
map("n", "<leader>rf", function()
  snacks.rename.rename_file()
end, { desc = "Rename File" })

-- LazyGit (Floating terminal)
map("n", "<leader>gl", function()
  snacks.lazygit()
end, { desc = "LazyGit" })

-- Files
map("n", "<leader>sf", function()
  Snacks.picker.files({ matcher = { frecency = true, history_bonus = true, ignorecase = false } })
end, { desc = "Search Files" })
map("n", "<leader>s.", function()
  Snacks.picker.recent()
end, { desc = "Recent Files" })
map("n", "<leader><leader>", function()
  Snacks.picker.buffers()
end, { desc = "Open Buffers" })

-- Search / Grep
map("n", "<leader>sg", function()
  Snacks.picker.grep()
end, { desc = "Live Grep" })
map({ "n", "x" }, "<leader>sw", function()
  Snacks.picker.grep_word()
end, { desc = "Grep Current Word" })
map("n", "<leader>/", function()
  Snacks.picker.lines()
end, { desc = "Grep Buffer" })

-- Diagnostics / LSP
map("n", "<leader>sd", function()
  Snacks.picker.diagnostics_buffer()
end, { desc = "Document Diagnostics" })
map("n", "<leader>sD", function()
  Snacks.picker.diagnostics()
end, { desc = "Workspace Diagnostics" })
map("n", "<leader>sq", function()
  Snacks.picker.qflist()
end, { desc = "Quickfix List" })

-- Metasearch
map("n", "<leader>sb", function()
  Snacks.picker.pickers()
end, { desc = "Snacks Pickers" })
map("n", "<leader>sh", function()
  Snacks.picker.help()
end, { desc = "Search Help" })
map("n", "<leader>sk", function()
  Snacks.picker.keymaps()
end, { desc = "Search Keymaps" })
