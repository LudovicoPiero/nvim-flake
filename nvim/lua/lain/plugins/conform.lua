local conform = require("conform")

local prettier_fts = {
  "html",
  "css",
  "scss",
  "less",
  "json",
  "yaml",
  "markdown",
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
}

-- Formatters by filetype.
local formatters_by_ft = {
  lua = { "stylua" },
  python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
  nix = { "nixfmt" },
  go = { "gofumpt", "goimports" },
  rust = { "rustfmt" },

  sh = { "shellharden", "shfmt" },
  bash = { "shellharden", "shfmt" },

  c = { "clang-format" },
  cpp = { "clang-format" },
  cmake = { "cmake_format" },

  toml = { "taplo" },
  gn = { "gn" },
}

-- Use Prettier for web filetypes.
for _, ft in ipairs(prettier_fts) do
  formatters_by_ft[ft] = { "prettier" }
end

-- Setup Conform.
conform.setup({
  notify_on_error = false,
  formatters_by_ft = formatters_by_ft,

  -- Configure formatters with custom arguments.
  formatters = {
    stylua = {
      prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
    },
    nixfmt = {
      prepend_args = { "--strict", "--width=80" },
    },
    shfmt = {
      prepend_args = { "-i", "2", "-ci" },
    },
  },
})

-- Formatting keymap.
vim.keymap.set("n", "<leader>ff", function()
  conform.format({
    async = true,
    lsp_format = "fallback",
  })
end, { desc = "[F]ormat [F]ile" })
