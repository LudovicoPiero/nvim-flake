-- nvim/lua/lain/lsp/utils.lua
local M = {}

function M.get_capabilities()
  local cmp_capabilities = require("blink.cmp").get_lsp_capabilities()
  local base_cap = vim.lsp.protocol.make_client_capabilities()
  local capabilities = vim.tbl_deep_extend("force", base_cap, cmp_capabilities)
  capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
  return capabilities
end

return M
