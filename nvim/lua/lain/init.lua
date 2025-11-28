local M = {}

-- Core configuration.
require("lain.core.globals")
require("lain.core.options")
require("lain.core.keymaps")
require("lain.core.autocmd")
require("lain.core.colorscheme")

-- LSP and plugins.
require("lain.lsp")
require("lain.plugins")

return M
