local noice = require("noice")

noice.setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
    -- Improve signature help visuals
    signature = {
      enabled = true,
      auto_open = {
        enabled = true,
        trigger = true,
        throttle = 50,
      },
    },
  },

  -- Presets
  presets = {
    bottom_search = true, -- Classic search bar at the bottom
    command_palette = true, -- Center cmdline for :commands
    long_message_to_split = true, -- Long messages go to a split
    inc_rename = false, -- Input dialog for inc-rename.nvim
    lsp_doc_border = true, -- CHANGED: True (Matches your rounded border theme)
  },

  views = {
    cmdline_popup = {
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
    },
    hover = {
      border = {
        style = "rounded",
      },
      position = { row = 2, col = 2 },
    },
  },

  -- Filters: Suppress annoying messages
  routes = {
    {
      filter = {
        event = "msg_show",
        kind = "",
        find = "written", -- Skip "file.lua [10L, 200B] written" messages
      },
      opts = { skip = true },
    },
  },
})

-- Keymaps
local map = vim.keymap.set
map("n", "<leader>nd", "<cmd>NoiceDismiss<cr>", { desc = "Dismiss Notification" })
