local blink_pairs = require("blink.pairs")
local blink_cmp = require("blink.cmp")
local copilot = require("copilot")

-- 1. Setup Blink Pairs
blink_pairs.setup({
  mappings = {
    enabled = true,
    pairs = { ["'"] = {} },
  },
  highlights = {
    enabled = true,
    matchparen = { enabled = true, group = "MatchParen" },
  },
})

-- Toggle keymap
vim.keymap.set("n", "<leader>tp", function()
  vim.g.blink_pairs_disabled = not vim.g.blink_pairs_disabled
  if vim.g.blink_pairs_disabled then
    require("blink.pairs.mappings").disable()
  else
    require("blink.pairs.mappings").enable()
  end
end, { desc = "[T]oggle auto [P]airs" })

-- 2. Setup Copilot (Backend)
copilot.setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
  filetypes = {
    gitcommit = true,
    markdown = true,
    help = true,
  },
})

-- 3. Setup Blink CMP
blink_cmp.setup({
  -- Disable cmdline completion (cleaner UI)
  cmdline = { enabled = false },

  keymap = {
    preset = "enter",
    ["<C-y>"] = { "select_and_accept" },
  },

  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = "mono",
    -- Native icon definition (Replaces lspkind)
    kind_icons = {
      Copilot = "",
      Text = "󰉿",
      Method = "󰆧",
      Function = "󰊕",
      Constructor = "",
      Field = "󰜢",
      Variable = "󰀫",
      Class = "󰠱",
      Interface = "",
      Module = "",
      Property = "󰜢",
      Unit = "󰑭",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "󰈇",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰏿",
      Struct = "󰙅",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "",
    },
  },

  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
    ghost_text = { enabled = true },

    menu = {
      border = "rounded",
      draw = {
        treesitter = { "lsp" },
        columns = {
          { "kind_icon" },
          { "label", "label_description", gap = 1 },
          { "kind" },
        },
      },
    },
  },

  sources = {
    default = { "copilot", "lsp", "snippets", "buffer", "path" },
    providers = {
      buffer = {
        min_keyword_length = function()
          return vim.bo.filetype == "markdown" and 0 or 1
        end,
      },
      lsp = { score_offset = 4 },
      snippets = {
        score_offset = 4,
      },
      path = {
        score_offset = 3,
        opts = {
          trailing_slash = true,
          show_hidden_files_by_default = false,
        },
      },
      copilot = {
        name = "copilot",
        module = "blink-copilot",
        score_offset = 100, -- Force Copilot to top
        async = true,
      },
    },
  },

  -- If you want to use Luasnip for snippets:
  snippets = { preset = "luasnip" },

  -- Use pre-built binaries (faster startup)
  fuzzy = { implementation = "rust" },

  signature = {
    enabled = true,
    window = { border = "rounded" },
  },
})
