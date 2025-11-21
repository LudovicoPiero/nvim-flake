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
  -- Optional: Better icon integration if using mini.icons or nvim-web-devicons
  file_icon_provider = "devicons",
})

-- Register as the default selector for vim.ui.select
fzf.register_ui_select()

-- Keymaps
local map = vim.keymap.set
local keys = {
  -- Files
  { "<leader>sf", fzf.files, "Search Files" },
  { "<leader>s.", fzf.oldfiles, "Recent Files" },
  { "<leader><leader>", fzf.buffers, "Open Buffers" },

  -- Search / Grep
  { "<leader>sg", fzf.live_grep, "Live Grep" },
  { "<leader>sw", fzf.grep_cword, "Grep Current Word" },
  { "<leader>/", fzf.lgrep_curbuf, "Grep Buffer" },

  -- Diagnostics / LSP
  { "<leader>sd", fzf.diagnostics_document, "Document Diagnostics" },
  { "<leader>sD", fzf.diagnostics_workspace, "Workspace Diagnostics" },
  { "<leader>sq", fzf.quickfix, "Quickfix List" },

  -- Metasearch
  { "<leader>sb", fzf.builtin, "FzfLua Builtins" },
  { "<leader>sh", fzf.helptags, "Search Help" },
  { "<leader>sk", fzf.keymaps, "Search Keymaps" },
}

for _, k in ipairs(keys) do
  map("n", k[1], k[2], { desc = "[S]earch: " .. k[3] })
end
