local M = {}

-- Get the directory of the current file (lua/lain/plugins/)
-- debug.getinfo(1).source returns "@.../path/to/file.lua", :sub(2) removes the @
local current_file = debug.getinfo(1, "S").source:sub(2)
local plugin_dir = vim.fn.fnamemodify(current_file, ":h")

-- Iterate over the directory using vim.fs (Native Nvim 0.10+ API)
for name, type in vim.fs.dir(plugin_dir) do
  -- Check if it's a file and ends with .lua
  if type == "file" and name:match("%.lua$") then
    -- Strip extension to get module name
    local module_name = name:gsub("%.lua$", "")

    -- Don't load 'init.lua' (this file) to avoid infinite recursion
    if module_name ~= "init" then
      local import_path = "lain.plugins." .. module_name

      -- Safely require the module
      local ok, err = pcall(require, import_path)
      if not ok then
        vim.notify("Failed to load plugin config: " .. module_name .. "\n\n" .. err, vim.log.levels.ERROR)
      end
    end
  end
end

return M
