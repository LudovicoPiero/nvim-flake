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
  require("fzf-lua").live_grep({
    prompt = "TODOs> ",
    search = "TODO|FIX|HACK|PERF|NOTE|WARNING", -- The keywords you care about
    no_esc = true, -- Treat the pipe | as an OR operator, not a literal character
  })
end, { desc = "[S]earch [T]odos" })
