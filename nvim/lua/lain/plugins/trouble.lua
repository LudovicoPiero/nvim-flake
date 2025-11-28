local trouble = require("trouble")

trouble.setup({
  auto_close = false,
  focus = true,

  icons = {
    indent = {
      top = "│ ",
      middle = "├╴",
      last = "└╴",
      fold_open = " ",
      fold_closed = " ",
      ws = "  ",
    },
    folder_closed = " ",
    folder_open = " ",
  },
})

local map = vim.keymap.set

-- Diagnostics
map("n", "<leader>xx", function()
  trouble.toggle("diagnostics")
end, { desc = "Diagnostics (Workspace)" })

map("n", "<leader>xX", function()
  trouble.toggle({ mode = "diagnostics", filter = { buf = 0 } })
end, { desc = "Diagnostics (Buffer)" })

-- LSP integration
map("n", "<leader>cs", function()
  -- Keep focus in editor.
  trouble.toggle({ mode = "symbols", focus = false })
end, { desc = "LSP Symbols" })

map("n", "<leader>cl", function()
  trouble.toggle({
    mode = "lsp",
    focus = false,
    win = { position = "right" }, -- Show on right.
  })
end, { desc = "LSP Definitions / References" })

-- Vim lists
map("n", "<leader>xL", function()
  trouble.toggle("loclist")
end, { desc = "Location List" })

map("n", "<leader>xQ", function()
  trouble.toggle("qflist")
end, { desc = "Quickfix List" })
