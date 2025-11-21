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

-- 2. Build the Filetype Map
local formatters_by_ft = {
  -- Core
  lua = { "stylua" },
  python = { "ruff_fix", "ruff_format" },
  nix = { "nixfmt" },
  go = { "gofumpt", "goimports" },
  rust = { "rustfmt" },

  sh = { "shellharden", "shfmt" },
  bash = { "shellharden", "shfmt" },

  -- C/C++
  c = { "clang-format" },
  cpp = { "clang-format" },
  cmake = { "cmake_format" },

  -- Misc
  toml = { "taplo" },
  gn = { "gn" },
}

-- Assign Prettier to all web types
for _, ft in ipairs(prettier_fts) do
  formatters_by_ft[ft] = { "prettier" }
end

-- 3. Setup
conform.setup({
  notify_on_error = false,
  formatters_by_ft = formatters_by_ft,

  -- Only configure formatters that need CUSTOM arguments.
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
    -- Python: Ruff specific setup
    ruff_format = {
      command = "ruff",
      args = { "format", "--stdin-filename", "$FILENAME", "-" },
      stdin = true,
    },
    ruff_fix = {
      command = "ruff",
      args = { "check", "--fix", "--stdin-filename", "$FILENAME", "-" },
      stdin = true,
    },
  },
})

-- 4. Keymap
vim.keymap.set("n", "<leader>ff", function()
  conform.format({
    async = true,
    lsp_format = "fallback",
  })
end, { desc = "[F]ormat [F]ile" })
