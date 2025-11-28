local M = {}

-- Get current directory.
-- (strips the '@' from the path)
local current_file = debug.getinfo(1, "S").source:sub(2)
local plugin_dir = vim.fn.fnamemodify(current_file, ":h")

-- Iterate over plugin files.
for name, type in vim.fs.dir(plugin_dir) do
  -- Require all .lua files.
  if type == "file" and name:match("%.lua$") then
    -- Get module name from filename.
    local module_name = name:gsub("%.lua$", "")

    -- Avoid infinite recursion.
    if module_name ~= "init" then
      local import_path = "lain.plugins." .. module_name

      -- Load the module.
      local ok, err = pcall(require, import_path)
      if not ok then
        vim.notify("Failed to load plugin config: " .. module_name .. "\n\n" .. err, vim.log.levels.ERROR)
      end
    end
  end
end

return M
