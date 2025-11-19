local M = {}

local fidget = require("fidget")
local lsp_utils = require("lain.lsp.utils")
local servers = require("lain.lsp.servers")

-- Initialize fidget (LSP progress indicator)
fidget.setup({})

--------------------------------------------------------------------------------
-- Diagnostic config
--------------------------------------------------------------------------------
vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  } or {},
  virtual_text = {
    source = "if_many",
    spacing = 2,
    format = function(diagnostic)
      return diagnostic.message
    end,
  },
})

--------------------------------------------------------------------------------
-- Common on_attach and LspAttach behavior
--------------------------------------------------------------------------------
local diag_float = {}

local function on_attach_common(client, bufnr)
  -- Floating diagnostics on CursorHold
  local augroup = vim.api.nvim_create_augroup("LspDiagnosticsFloat", { clear = true })
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    group = augroup,
    callback = function()
      local line = vim.api.nvim_win_get_cursor(0)[1]

      if diag_float[bufnr] then
        local win = diag_float[bufnr].win
        if win and vim.api.nvim_win_is_valid(win) and diag_float[bufnr].line == line then
          return
        end
        if win and vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end

      local diagnostics = vim.diagnostic.get(0, { lnum = line - 1 })
      if vim.tbl_isempty(diagnostics) then
        diag_float[bufnr] = nil
        return
      end

      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "always",
        prefix = " ",
        scope = "line",
      }

      local float_win = vim.diagnostic.open_float(nil, opts)
      if float_win then
        diag_float[bufnr] = { win = float_win, line = line }
      else
        diag_float[bufnr] = nil
      end
    end,
  })

  -- FZF-based LSP keymaps
  local fzf = require("fzf-lua")
  vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "Go to definition", buffer = bufnr })
  vim.keymap.set("n", "gi", fzf.lsp_implementations, { desc = "Go to implementation", buffer = bufnr })
  vim.keymap.set("n", "gr", fzf.lsp_references, { desc = "Find references", buffer = bufnr })
  vim.keymap.set("n", "<leader>ca", fzf.lsp_code_actions, { desc = "[C]ode [A]ctions", buffer = bufnr })
  vim.keymap.set("n", "<leader>D", fzf.lsp_typedefs, { desc = "Go to type definition", buffer = bufnr })
  vim.keymap.set("n", "<leader>sS", vim.lsp.buf.signature_help, { desc = "[S]how [S]ignature", buffer = bufnr })
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation", buffer = bufnr })
  vim.keymap.set("n", "<leader>n", vim.lsp.buf.rename, { desc = "Rename symbol", buffer = bufnr })
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, { desc = "Prev diagnostic", buffer = bufnr })
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, { desc = "Next diagnostic", buffer = bufnr })
end

-- Get capabilities
local capabilities = lsp_utils.get_capabilities()

-- Setup servers
servers.setup(on_attach_common, capabilities)

return M

