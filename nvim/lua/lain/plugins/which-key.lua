local wk = require("which-key")

local has_icons = vim.g.have_nerd_font

wk.setup({
  preset = "helix",
  delay = 0,

  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group

    mappings = has_icons, -- Use icons for mappings?

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

  -- Layout configuration
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },

  -- Document key chains with explicit icons
  spec = {
    { "<leader>b", group = "Buffers", icon = "󰓩 " },
    { "<leader>c", group = "Code", icon = "󰅱 " },
    { "<leader>d", group = "Document", icon = "󰈙 " },
    { "<leader>f", group = "Format", icon = "Uc " },
    { "<leader>g", group = "Git", icon = "󰊢 " },
    { "<leader>s", group = "Search", icon = "󰍉 " },
    { "<leader>t", group = "Toggle", icon = " " },
    { "<leader>x", group = "Trouble", icon = "󰅚 " },

    -- LSP Specific
    { "g", group = "Go To", icon = " " },
    { "gr", group = "LSP References", icon = " " },
  },
})
