-- nvim/lua/lain/init.lua
local M = {}

-- Load core configuration
require("lain.core.globals")
require("lain.core.options")
require("lain.core.keymaps")
require("lain.core.autocmd")
require("lain.core.colorscheme")

-- Load LSP and plugin configurations
require("lain.lsp")
require("lain.plugins")

return M
