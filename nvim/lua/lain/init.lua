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

-- uncomment the line below to get a notification when the config is reloaded
-- vim.notify("Lain's Neovim config loaded!", vim.log.levels.INFO)

return M
