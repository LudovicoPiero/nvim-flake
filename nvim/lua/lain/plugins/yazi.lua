local yazi = require("yazi")

yazi.setup({
  open_for_directories = false,
  keymaps = {
    show_help = "<F1>",
    open_file_in_vertical_split = "<c-v>",
    open_file_in_horizontal_split = "<c-x>",
    open_file_in_tab = "<c-t>",
    grep_in_directory = "<c-s>",
    replace_in_directory = "<c-g>",
    cycle_open_buffers = "<tab>",
    copy_relative_path = "<c-y>",
    send_to_quickfix = "<c-q>",
  },
  floating_window_scaling_factor = 0.85,
  yazi_floating_window_winblend = 0,
  yazi_floating_window_border = "rounded",
})

local map = vim.keymap.set

-- Open at current file.
map("n", "<leader>ty", function()
  yazi.yazi()
end, { desc = "Yazi (Current File)" })

-- Open at CWD.
map("n", "<leader>tc", function()
  yazi.yazi(nil, vim.fn.getcwd())
end, { desc = "Yazi (CWD)" })

-- Toggle last session.
map("n", "<leader>tt", function()
  yazi.toggle()
end, { desc = "Yazi (Toggle)" })
