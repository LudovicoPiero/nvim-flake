local neogit = require("neogit")

-- 1. Setup Neogit
-- Magit for Neovim
neogit.setup({
  kind = "floating", -- "tab" | "split" | "floating"
  integrations = {
    diffview = true, -- Opens diffs in Diffview instead of internal view
  },
})

-- 2. Keymaps
local map = vim.keymap.set

-- Neogit
map("n", "<leader>gg", neogit.open, { desc = "Neogit Status" })
map("n", "<leader>gc", ":Neogit commit<CR>", { desc = "Neogit Commit" })
