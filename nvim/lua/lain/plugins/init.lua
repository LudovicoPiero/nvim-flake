local M = {}

local function load_plugin(name)
  local ok, err = pcall(require, "lain.plugins." .. name)
  if not ok then
    vim.notify("Error loading plugin '" .. name .. "':\n" .. err, vim.log.levels.ERROR)
  end
end

-- List of plugins to load
local plugins = {
  "blink",
  "bufferline",
  "conform",
  "flash",
  "fyler",
  "fzf-lua",
  "gitsigns",
  "guess-indent",
  "indent-blankline",
  "mini",
  "neogit",
  "todo-comments",
  "treesitter",
  "trouble",
  "which-key",
  "yazi",
}

for _, plugin_name in ipairs(plugins) do
  load_plugin(plugin_name)
end

return M

