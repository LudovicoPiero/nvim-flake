---@diagnostic disable: undefined-global
local todo = require("todo-comments")

todo.setup({
  signs = false,
  highlight = {
    multiline = true,
    multiline_pattern = "^.",
    multiline_context = 10,
    before = "",
    keyword = "wide",
    after = "fg",
  },
})

vim.keymap.set("n", "<leader>st", function()
  Snacks.picker.todo_comments()
end, { desc = "[S]earch [T]odos" })
vim.keymap.set("n", "<leader>sT", function()
  Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
end, { desc = "[S]earch [T]odos" })
