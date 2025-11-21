local bufferline = require("bufferline")

bufferline.setup({
  options = {
    mode = "buffers", -- set to "tabs" to only show tabpages instead
    themable = true, -- Allows onedark to override highlights
    numbers = "none", -- "ordinal" | "buffer_id" | "both" | function
    indicator = {
      style = "none", -- Don't show the little bar on the left, let highlights do the work
    },

    -- Visuals
    separator_style = "thin", -- "slant" | "slope" | "thick" | "thin"
    show_buffer_close_icons = false,
    show_close_icon = false,
    color_icons = true, -- Filetype icons (requires nvim-web-devicons)

    -- Diagnostics
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,

    -- Custom Diagnostic Icons (Matches your LSP config)
    diagnostics_indicator = function(count, level)
      local icon = level:match("error") and "󰅚 " or "󰀪 "
      return " " .. icon .. count
    end,

    -- Handling Sidebars (NvimTree, Neo-tree, etc.)
    offsets = {
      {
        filetype = "NvimTree",
        text = "Explorer",
        text_align = "left",
        separator = true,
      },
      {
        filetype = "neo-tree",
        text = "Explorer",
        text_align = "left",
        separator = true,
      },
    },

    -- Behavior
    enforce_regular_tabs = false,
    always_show_bufferline = true,
    sort_by = "insert_after_current",
  },
})

-- Keymaps
local map = vim.keymap.set

-- 1. Standard Cycling (Much faster for quick switching)
map("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })

-- 2. Buffer Picking (Jump to specific buffer)
map("n", "<leader>bp", "<cmd>BufferLinePick<cr>", { desc = "Pick Buffer" })

-- 3. Buffer Closing
map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close Other Buffers" })
