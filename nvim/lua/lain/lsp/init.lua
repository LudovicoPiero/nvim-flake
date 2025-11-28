---@diagnostic disable: undefined-global
local M = {}

local lsp_utils = require("lain.lsp.utils")
local servers = require("lain.lsp.servers")

--------------------------------------------------------------------------------
-- Diagnostic Config
--------------------------------------------------------------------------------
vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  float = {
    border = "rounded",
    source = "if_many",
    header = "",
    prefix = "",
  },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  },
  virtual_text = {
    source = "if_many",
    spacing = 2,
    format = function(diagnostic)
      return diagnostic.message
    end,
  },
})

--------------------------------------------------------------------------------
-- LSP Attach Logic
--------------------------------------------------------------------------------
-- stylua: ignore start
local diagnostic_augroup = vim.api.nvim_create_augroup("LspDiagnosticsFloat", { clear = true })
local function on_attach_common(client, bufnr)
  -- Helper: Easier key mapping
  local map = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
  end

  -- 1. Auto-Show Diagnostics on Hover
  --    Scope = 'cursor' keeps it less noisy than 'line'
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    group = diagnostic_augroup,
    callback = function()
      vim.diagnostic.open_float(nil, {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "always",
        prefix = " ",
        scope = "cursor",
      })
    end,
  })

  -- 2. Navigation (Snacks)
  map("gd", function() Snacks.picker.lsp_definitions() end, "Go to Definition")
  map("gD", function() Snacks.picker.lsp_declarations() end, "Go to Declaration")
  map("gi", function() Snacks.picker.lsp_implementations() end, "Go to Implementation")
  map("grr", function() Snacks.picker.lsp_references() end, "Find References")
  map("<leader>D", function() Snacks.picker.lsp_type_definitions() end, "Type Definition")

  -- 2.1 Call Hierarchy & Symbols
  map("gai", function() Snacks.picker.lsp_incoming_calls() end, "Calls Incoming")
  map("gao", function() Snacks.picker.lsp_outgoing_calls() end, "Calls Outgoing")
  map("<leader>ss", function() Snacks.picker.lsp_symbols() end, "Document Symbols")
  map("<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, "Workspace Symbols")

  -- 3. Actions & Info (Native)
  map("<leader>ca", vim.lsp.buf.code_action, "Code Actions")
  map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
  map("K", vim.lsp.buf.hover, "Hover Documentation")
  map("gK", vim.lsp.buf.signature_help, "Signature Help")

  -- 4. Diagnostics (Jump)
  map("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev Diagnostic")
  map("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next Diagnostic")

  -- 5. Toggles
  if client.server_capabilities.inlayHintProvider then
    map("<leader>th", function()
      local current = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
      vim.lsp.inlay_hint.enable(not current, { bufnr = bufnr })
    end, "Toggle Inlay Hints")
  end
end
-- stylua: ignore end

-- Get capabilities
local capabilities = lsp_utils.get_capabilities()

-- Setup servers
servers.setup(on_attach_common, capabilities)

return M
