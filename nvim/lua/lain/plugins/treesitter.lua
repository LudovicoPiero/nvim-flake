require("nvim-treesitter.configs").setup({
  -- Parsers are managed by Nix.
  ensure_installed = {},
  auto_install = false,
  sync_install = false,

  highlight = {
    enable = true,
    -- Use regex highlighting for Ruby.
    additional_vim_regex_highlighting = { "ruby" },
  },

  indent = {
    enable = true,
    disable = { "ruby" },
  },

  -- Incremental selection.
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>", -- Start selection.
      node_incremental = "<C-space>", -- Expand.
      scope_incremental = false,
      node_decremental = "<bs>", -- Shrink.
    },
  },
})
