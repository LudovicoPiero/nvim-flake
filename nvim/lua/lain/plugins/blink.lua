local blink_pairs = require("blink.pairs")
local blink_cmp = require("blink.cmp")
local copilot = require("copilot")
require("luasnip.loaders.from_vscode").lazy_load()

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
  cmdline = { enabled = false },

  keymap = {
    preset = "enter",
    ["<C-y>"] = { "select_and_accept" },
  },

  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = "mono",
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
        components = {
          -- Custom kind_icon to render highlighting from nvim-highlight-colors
          kind_icon = {
            text = function(ctx)
              local icon = ctx.kind_icon
              -- if LSP source, check for color derived from documentation
              if ctx.item.source_name == "LSP" then
                local color_item = require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                if color_item and color_item.abbr ~= "" then
                  icon = color_item.abbr
                end
              end
              return icon .. ctx.icon_gap
            end,
            highlight = function(ctx)
              local highlight = "BlinkCmpKind" .. ctx.kind
              if ctx.item.source_name == "LSP" then
                local color_item = require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                if color_item and color_item.abbr_hl_group then
                  highlight = color_item.abbr_hl_group
                end
              end
              return highlight
            end,
          },
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
      snippets = { score_offset = 4 },
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
        score_offset = 100,
        async = true,
      },
    },
  },

  snippets = { preset = "luasnip" },
  fuzzy = { implementation = "rust" },
  signature = {
    enabled = true,
    window = { border = "rounded" },
  },
})
