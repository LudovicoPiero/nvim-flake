local wk = require("which-key")

local has_icons = vim.g.have_nerd_font

wk.setup({
  preset = "helix",
  delay = 0,

  icons = {
    breadcrumb = "»", -- Breadcrumb symbol.
    separator = "➜", -- Separator symbol.
    group = "+", -- Group symbol.
    mappings = has_icons, -- Use icons.

    keys = has_icons and {} or {
      Up = "<Up> ",
      Down = "<Down> ",
      Left = "<Left> ",
      Right = "<Right> ",
      C = "^",
      M = "M-",
      D = "D-",
      S = "S-",
      CR = "Ent",
      Esc = "Esc",
      ScrollWheelDown = "ScrDn ",
      ScrollWheelUp = "ScrUp ",
      NL = "NL ",
      BS = "BS ",
      Space = "Spc ",
      Tab = "Tab ",
      F1 = "F1",
      F2 = "F2",
      F3 = "F3",
      F4 = "F4",
      F5 = "F5",
      F6 = "F6",
      F7 = "F7",
      F8 = "F8",
      F9 = "F9",
      F10 = "F10",
      F11 = "F11",
      F12 = "F12",
    },
  },

  -- Layout.
  layout = {
    height = { min = 4, max = 25 }, -- Column height.
    width = { min = 20, max = 50 }, -- Column width.
    spacing = 3, -- Column spacing.
    align = "left", -- Column alignment.
  },

  -- Add icons to key chains.
  spec = {
    { "<leader>b", group = "Buffers", icon = "󰓩 " },
    { "<leader>c", group = "Code", icon = "󰅱 " },
    { "<leader>d", group = "Document", icon = "󰈙 " },
    { "<leader>f", group = "Format", icon = "Uc " },
    { "<leader>g", group = "Git", icon = "󰊢 " },
    { "<leader>s", group = "Search", icon = "󰍉 " },
    { "<leader>t", group = "Toggle", icon = " " },
    { "<leader>x", group = "Trouble", icon = "󰅚 " },

    -- LSP.
    { "g", group = "Go To", icon = " " },
    { "gr", group = "LSP References", icon = " " },
  },
})
