local null_ls = require("null-ls")
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

null_ls.setup({
  sources = {
    -- Nix
    -- deadnix: Dead code detection.
    diagnostics.deadnix,
    -- statix: Anti-pattern checking.
    diagnostics.statix,
    -- statix: Code actions.
    code_actions.statix,

    -- Go
    diagnostics.golangci_lint,

    -- TODO: Add more sources.
  },
})
