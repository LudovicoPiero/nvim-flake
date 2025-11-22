local M = {}

local lsp_utils = require("lain.lsp.utils")
local servers = require("lain.lsp.servers")

--------------------------------------------------------------------------------
-- Diagnostic Config
--------------------------------------------------------------------------------
-- Define signs once, cleaner
local signs = {
  [vim.diagnostic.severity.ERROR] = "󰅚 ",
  [vim.diagnostic.severity.WARN] = "󰀪 ",
  [vim.diagnostic.severity.INFO] = "󰋽 ",
  [vim.diagnostic.severity.HINT] = "󰌶 ",
}

vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = { text = signs }, -- Neovim 0.10+ handles checking for font support better usually, but this is safe
  virtual_text = {
    source = "if_many",
    spacing = 2,
    format = function(diagnostic)
      return diagnostic.message
    end,
  },
  -- This updates diagnostics in insert mode, usually annoying, keep false
  update_in_insert = false,
})

--------------------------------------------------------------------------------
-- LSP Attach Logic
--------------------------------------------------------------------------------
local function on_attach_common(client, bufnr)
  -- 1. Auto-Show Diagnostics on Hover (Refactored)
  -- We don't need to manually manage window IDs anymore.
  -- scope="cursor" is less intrusive than "line"
  local augroup = vim.api.nvim_create_augroup("LspDiagnosticsFloat", { clear = true })
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    group = augroup,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "always",
        prefix = " ",
        scope = "cursor", -- Changed from 'line' to 'cursor' to reduce noise
      }
      vim.diagnostic.open_float(nil, opts)
    end,
  })

  -- 2. Keymaps (FZF-Lua + Native)
  local fzf = require("fzf-lua")
  local map = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
  end

  -- Navigation
  map("gd", fzf.lsp_definitions, "Go to Definition")
  map("gi", fzf.lsp_implementations, "Go to Implementation")
  map("grr", fzf.lsp_references, "Find References")
  map("<leader>D", fzf.lsp_typedefs, "Type Definition")

  -- Actions
  map("<leader>ca", fzf.lsp_code_actions, "Code Actions")
  map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol") -- Standard is <leader>rn or grn

  -- Info
  map("<leader>sS", vim.lsp.buf.signature_help, "Signature Help")
  map("K", vim.lsp.buf.hover, "Hover Documentation")

  -- Diagnostics (Modern 0.11+ API)
  map("[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, "Prev Diagnostic")
  map("]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, "Next Diagnostic")

  -- Toggle Inlay Hints (Neovim 0.10+ feature)
  if client.server_capabilities.inlayHintProvider then
    map("<leader>th", function()
      local current = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
      vim.lsp.inlay_hint.enable(not current, { bufnr = bufnr })
    end, "Toggle Inlay Hints")
  end
end

-- Get capabilities
local capabilities = lsp_utils.get_capabilities()

-- Setup servers
servers.setup(on_attach_common, capabilities)

return M
