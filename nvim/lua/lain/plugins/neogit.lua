---@diagnostic disable: undefined-global
require("diffview").setup({})

require("neogit").setup({})
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit UI" })
