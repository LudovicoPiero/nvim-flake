local has_icons = vim.g.have_nerd_font

--------------------------------------------------------------------------------
-- 1. Mini AI & SplitJoin
--------------------------------------------------------------------------------
require("mini.ai").setup({ n_lines = 500 })
require("mini.splitjoin").setup()

--------------------------------------------------------------------------------
-- 2. Mini Surround
--------------------------------------------------------------------------------
require("mini.surround").setup({
  mappings = {
    add = "gsa", -- Add surrounding in Normal and Visual modes
    delete = "gsd", -- Delete surrounding
    find = "gsf", -- Find surrounding (to the right)
    find_left = "gsF", -- Find surrounding (to the left)
    highlight = "gsh", -- Highlight surrounding
    replace = "gsr", -- Replace surrounding
    update_n_lines = "gsn", -- Update `n_lines`
  },
})

--------------------------------------------------------------------------------
-- 3. Mini Statusline
--------------------------------------------------------------------------------
local statusline = require("mini.statusline")
statusline.setup({ use_icons = has_icons })

-- Override location section to simple LINE:COL
statusline.section_location = function()
  return "%2l:%-2v"
end

--------------------------------------------------------------------------------
-- 4. Mini BufRemove (Smart Buffer Closing)
--------------------------------------------------------------------------------
require("mini.bufremove").setup()

local function close_buffer(force)
  local bd = require("mini.bufremove").delete

  if force then
    bd(0, true)
    return
  end

  if vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
    if choice == 1 then -- Yes
      vim.cmd.write()
      bd(0)
    elseif choice == 2 then -- No
      bd(0, true)
    end
  else
    bd(0)
  end
end

vim.keymap.set("n", "<leader>bd", function()
  close_buffer(false)
end, { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>bD", function()
  close_buffer(true)
end, { desc = "Force Delete Buffer" })
