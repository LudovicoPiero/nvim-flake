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
-- 4. Mini Misc (Restore Cursor)
--------------------------------------------------------------------------------
local misc = require("mini.misc")
misc.setup()
vim.filetype.add({
  filename = {
    ["COMMIT_EDITMSG"] = "gitcommit",
    ["git-rebase-todo"] = "gitrebase",
  },
})
vim.g.minimisc_restore_cursor_ignore_filetypes = { "gitcommit", "gitrebase" }
misc.setup_restore_cursor()
