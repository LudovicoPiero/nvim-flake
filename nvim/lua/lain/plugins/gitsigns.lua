local gitsigns = require("gitsigns")

gitsigns.setup({
  -- Use bars for signs.
  signs = {
    add = { text = "┃" },
    change = { text = "┃" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },

  preview_config = {
    border = "rounded",
  },

  on_attach = function(bufnr)
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- Hunk navigation
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, "Next Git Hunk")

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, "Prev Git Hunk")

    -- Visual mode actions
    -- Use <leader>g prefix for consistency.
    map("v", "<leader>gs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Stage Hunk")

    map("v", "<leader>gr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Reset Hunk")

    -- Normal mode actions
    map("n", "<leader>gs", gitsigns.stage_hunk, "Stage Hunk")
    map("n", "<leader>gr", gitsigns.reset_hunk, "Reset Hunk")
    map("n", "<leader>gS", gitsigns.stage_buffer, "Stage Buffer")
    map("n", "<leader>gu", gitsigns.undo_stage_hunk, "Undo Stage Hunk")
    map("n", "<leader>gR", gitsigns.reset_buffer, "Reset Buffer")
    map("n", "<leader>gp", gitsigns.preview_hunk, "Preview Hunk")
    map("n", "<leader>gb", gitsigns.blame_line, "Blame Line")
    map("n", "<leader>gd", gitsigns.diffthis, "Diff (Index)")
    map("n", "<leader>gD", function()
      gitsigns.diffthis("@")
    end, "Diff (Commit)")

    -- Toggle commands
    map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Toggle Git Blame")
    map("n", "<leader>td", gitsigns.toggle_deleted, "Toggle Deleted")
  end,
})
