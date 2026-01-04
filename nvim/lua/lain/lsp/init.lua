---@diagnostic disable: undefined-global
local M = {}

vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  float = {
    border = "rounded",
    source = "if_many",
    header = "",
    prefix = "",
  },
  underline = true,
  signs = false,
  virtual_text = false,
})

require("lain.lsp.servers").setup()

return M
