-- nvim/lua/lain/lsp/utils.lua
local M = {}

function M.get_capabilities()
  -- 1. Get Blink capabilities
  -- This includes standard Neovim capabilities + Blink's completion optimizations
  local capabilities = require("blink.cmp").get_lsp_capabilities()

  -- 2. Add Folding capabilities (for nvim-ufo)
  -- This tells LSPs: "Hey, I can handle folding ranges, send them to me."
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  return capabilities
end

return M
