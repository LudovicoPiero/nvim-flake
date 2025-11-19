vim.keymap.set("n", "<Tab>", "<CMD>BufferLinePick<CR>", { silent = true })
-- vim.keymap.set("n", "<Tab>", "<CMD>bnext<CR>", { silent = true })
-- vim.keymap.set("n", "<S-Tab>", "<CMD>bprevious<CR>", { silent = true })

local bufferline = require("bufferline")
bufferline.setup({
  options = {
    show_close_icon = false,
    show_buffer_close_icons = false,
    separator_style = "thin",
    diagnostics = "nvim_lsp",
    themable = true,
    -- indicator = {
    --   style = "underline",
    -- },
    pick = {
      alphabet = "abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ1234567890",
    },
  },
})
