require("nvim-treesitter.configs").setup({
  -- Parsers are managed by Nix, so we disable auto-install
  ensure_installed = {},
  auto_install = false,
  sync_install = false,

  highlight = {
    enable = true,
    -- Ruby often behaves better with legacy syntax for highlighting specific edge cases
    additional_vim_regex_highlighting = { "ruby" },
  },

  indent = {
    enable = true,
    disable = { "ruby" },
  },

  -- Smart Selection: The best feature of Treesitter
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>", -- Start selecting with Ctrl+Space
      node_incremental = "<C-space>", -- Expand selection
      scope_incremental = false,
      node_decremental = "<bs>", -- Shrink selection with Backspace
    },
  },
})
