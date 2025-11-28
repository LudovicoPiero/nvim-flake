local null_ls = require("null-ls")
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

null_ls.setup({
  sources = {
    -- === NIX ===
    -- Dead code detection
    diagnostics.deadnix,
    -- Anti-pattern checking
    diagnostics.statix,
    -- Suggestions (e.g. fix 'unused let')
    code_actions.statix,

    -- === PYTHON ===
    -- Ruff is excellent for linting (imports, syntax, modernization)
    diagnostics.ruff,

    -- === GO ===
    -- The heavy hitter for Go linting
    diagnostics.golangci_lint,

    -- === SHELL ===
    -- Catch bash/sh errors
    diagnostics.shellcheck,
    code_actions.shellcheck,
  },
})
