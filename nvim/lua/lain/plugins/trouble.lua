local trouble = require("trouble")

trouble.setup({
  auto_close = false,
  focus = true,

  -- Visuals
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

-- Keymaps
local map = vim.keymap.set

-- 1. Diagnostics
map("n", "<leader>xx", function()
  trouble.toggle("diagnostics")
end, { desc = "Diagnostics (Workspace)" })

map("n", "<leader>xX", function()
  trouble.toggle({ mode = "diagnostics", filter = { buf = 0 } })
end, { desc = "Diagnostics (Buffer)" })

-- 2. LSP Integration
map("n", "<leader>cs", function()
  -- focus = false: keep cursor in code while seeing symbols on side
  trouble.toggle({ mode = "symbols", focus = false })
end, { desc = "LSP Symbols" })

map("n", "<leader>cl", function()
  trouble.toggle({
    mode = "lsp",
    focus = false,
    win = { position = "right" }, -- Show refs on the right side
  })
end, { desc = "LSP Definitions / References" })

-- 3. Vim Lists
map("n", "<leader>xL", function()
  trouble.toggle("loclist")
end, { desc = "Location List" })

map("n", "<leader>xQ", function()
  trouble.toggle("qflist")
end, { desc = "Quickfix List" })
