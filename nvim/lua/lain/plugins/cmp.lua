local cmp = require("cmp")
local luasnip = require("luasnip")
local autopairs = require("nvim-autopairs")
local copilot = require("copilot")
local copilot_cmp = require("copilot_cmp")

-- 1. Setup Copilot (Backend)
copilot.setup({
  suggestion = { enabled = false }, -- Disable standard virtual text
  panel = { enabled = false },
  filetypes = {
    gitcommit = true,
    markdown = true,
    help = true,
  },
})
copilot_cmp.setup()

-- 2. Setup Auto-pairs
autopairs.setup({
  check_ts = true, -- Enable treesitter integration
  fast_wrap = { map = "<M-e>" },
})

-- Connect Auto-pairs to CMP
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- 3. Load Snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- 4. Icons
local kind_icons = {
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
}

-- 5. CMP Setup
cmp.setup({
  -- Snippet Engine
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  completion = {
    -- menu: display popup menu
    -- menuone: display popup menu even if there is only one match
    -- noinsert: highlight the first item automatically (vs 'noselect')
    completeopt = "menu,menuone,noinsert",
  },

  preselect = cmp.PreselectMode.Item,

  -- Window Styling
  window = {
    completion = cmp.config.window.bordered({
      border = "rounded",
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
    }),
    documentation = cmp.config.window.bordered({
      border = "rounded",
    }),
  },

  -- Ghost Text
  experimental = {
    ghost_text = true,
  },

  -- Mappings
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),

    -- Accept
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),

    -- Tab
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),

  -- Formatting
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      -- Icons
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind])

      -- Source Labels
      vim_item.menu = ({
        copilot = "[AI]",
        nvim_lsp = "[LSP]",
        luasnip = "[Snip]",
        buffer = "[Buf]",
        path = "[Path]",
      })[entry.source.name]

      return vim_item
    end,
  },

  -- Sources & Sorting
  sorting = {
    priority_weight = 2,
    comparators = {
      require("copilot_cmp.comparators").prioritize,
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },

  sources = cmp.config.sources({
    { name = "nvim_lsp_signature_help" },
    { name = "copilot", group_index = 2 },
    { name = "nvim_lsp", group_index = 2 },
    { name = "luasnip", group_index = 2 },
    { name = "path", group_index = 2 },
  }, {
    { name = "buffer", group_index = 2 },
  }),
})
