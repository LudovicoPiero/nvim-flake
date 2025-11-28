---@diagnostic disable: undefined-global
-- Only run under Nix.
if mnw == nil then
  return
end

local plugin_root = mnw.configDir .. "/pack/mnw/start/lain/nvim"
vim.opt.rtp:prepend(plugin_root)

-- Add plugins to packpath.
vim.opt.packpath:prepend(mnw.configDir .. "/pack")

-- Load optional plugins.
local opt_dir = mnw.configDir .. "/pack/mnw/opt"
for name, type in vim.fs.dir(opt_dir) do
  if type == "directory" then
    pcall(vim.cmd.packadd, name)
  end
end

-- Load main configuration.
require("lain")
