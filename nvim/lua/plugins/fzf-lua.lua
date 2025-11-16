---@diagnostic disable: undefined-global
local fzf = require("fzf-lua")

fzf.setup({
  winopts = {
    height = 0.85,
    width = 0.80,
    row = 0.35,
    col = 0.50,
    border = "rounded",
    treesitter = {
      enabled = true,
      fzf_colors = { ["hl"] = "-1:reverse", ["hl+"] = "-1:reverse" },
    },
    preview = {
      layout = "flex",
      border = "rounded",
      warp = true,
      title = false,
      scrollbar = false,
      delay = 20,
      winopts = {
        number = true,
        relativenumber = false,
        cursorline = true,
        cursorlineopt = "both",
        cursorcolumn = false,
        signcolumn = "no",
        list = false,
        foldenable = false,
        foldmethod = "manual",
      },
    },
  },
  fzf_opts = {
    ["--ansi"] = true,
    ["--style"] = "minimal",
    ["--info"] = "inline-right",
    ["--height"] = "100%",
    ["--layout"] = "reverse",
    ["--border"] = "none",
    ["--highlight-line"] = true,
    ["--marker"] = "✓",
  },
})

-- Use fzf-lua for vim.ui.select
fzf.register_ui_select()

-- Keymaps
local map = vim.keymap.set

map("n", "<leader>c", "<cmd>FzfLua files<cr>", { desc = "Find Files" })
map("n", "<leader>sq", function()
  FzfLua.quickfix()
end, { desc = "[S]earch [Q]uickfix List" })
map("n", "<leader>sh", function()
  FzfLua.helptags()
end, { desc = "[S]earch [H]elp" })
map("n", "<leader>sk", function()
  FzfLua.keymaps()
end, { desc = "[S]earch [K]eymaps" })
map("n", "<leader>sf", function()
  FzfLua.files()
end, { desc = "[S]earch [F]iles" })
map("n", "<leader>sb", function()
  FzfLua.builtin()
end, { desc = "[S]earch [B]uiltin FzfLua" })
map("n", "<leader>sw", function()
  FzfLua.grep_cword()
end, { desc = "[S]earch current [W]ord" })
map("n", "<leader>sg", function()
  FzfLua.live_grep()
end, { desc = "[S]earch by [G]rep" })
map("n", "<leader>sd", function()
  FzfLua.diagnostics_document()
end, { desc = "[S]earch [d]iagnostic documents" })
map("n", "<leader>sD", function()
  FzfLua.diagnostics_workspace()
end, { desc = "[S]earch [D]iagnostic workspace" })
map("n", "<leader>s.", function()
  FzfLua.oldfiles()
end, { desc = "[S]earch Recent Files ('.' for repeat)" })
map("n", "<leader><leader>", function()
  FzfLua.buffers()
end, { desc = "[ ] Find existing buffers" })
map("n", "<leader>/", function()
  FzfLua.lgrep_curbuf()
end, { desc = "[S]earch [/] in Open Files" })
