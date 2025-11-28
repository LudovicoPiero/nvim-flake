local flash = require("flash")

flash.setup({
  labels = "asdfghjklqwertyuiopzxcvbnm",
  search = {
    mode = "fuzzy",
  },
  jump = {
    autojump = true,
  },
  modes = {
    char = {
      jump_labels = true, -- Show jump labels for f/t.
    },
  },
})

local map = vim.keymap.set
map("n", "s", function()
  flash.jump()
end, { desc = "Flash" })
map("n", "S", function()
  flash.treesitter()
end, { desc = "Flash Treesitter" })
map("o", "r", function()
  flash.remote()
end, { desc = "Remote Flash" })
map("o", "R", function()
  flash.treesitter_search()
end, { desc = "Treesitter Search" })
map("c", "<C-s>", function()
  flash.toggle()
end, { desc = "Toggle Flash Search" })
