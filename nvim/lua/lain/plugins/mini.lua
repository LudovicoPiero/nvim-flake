local has_icons = vim.g.have_nerd_font

-- mini.ai and mini.splitjoin
require("mini.ai").setup({ n_lines = 500 })
require("mini.splitjoin").setup()

-- mini.surround
require("mini.surround").setup({
  mappings = {
    add = "gsa", -- Add
    delete = "gsd", -- Delete
    find = "gsf", -- Find right
    find_left = "gsF", -- Find left
    highlight = "gsh", -- Highlight
    replace = "gsr", -- Replace
    update_n_lines = "gsn", -- Update n_lines
  },
})

-- mini.statusline
local statusline = require("mini.statusline")
statusline.setup({ use_icons = has_icons })
-- Show LINE:COL in statusline.
statusline.section_location = function()
  return "%2l:%-2v"
end

-- mini.misc
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
