local fyler = require("fyler")

local map = vim.keymap.set
map("n", "<leader>tf", "<CMD>Fyler<CR>", { desc = "[T]oggle [F]yler", silent = true })
map("n", "<leader>ts", "<CMD>Fyler kind=split_left_most<CR>", { desc = "[T]oggle Fyler [S]plit", silent = true })

fyler.setup({
  views = {
    finder = {
      -- Close on select.
      close_on_select = false,
      -- Auto-confirm simple actions.
      confirm_simple = false,
      -- Replace netrw.
      default_explorer = true,
      -- Delete to trash.
      delete_to_trash = false,
      git_status = {
        enabled = true,
        symbols = {
          Untracked = "?",
          Added = "+",
          Modified = "*",
          Deleted = "x",
          Renamed = ">",
          Copied = "~",
          Conflict = "!",
          Ignored = "#",
        },
      },
      indentscope = {
        enabled = true,
        group = "FylerIndentMarker",
        marker = "│",
      },
      mappings = {
        ["q"] = "CloseView",
        ["<CR>"] = "Select",
        ["<C-t>"] = "SelectTab",
        ["|"] = "SelectVSplit",
        ["-"] = "SelectSplit",
        ["^"] = "GotoParent",
        ["="] = "GotoCwd",
        ["."] = "GotoNode",
        ["#"] = "CollapseAll",
        ["<BS>"] = "CollapseNode",
      },
      -- Follow current file.
      follow_current_file = true,
      -- Watch filesystem.
      watcher = {
        enabled = false,
      },
      win = {
        border = vim.o.winborder == "" and "single" or vim.o.winborder,
        buf_opts = {
          filetype = "fyler",
          syntax = "fyler",
          buflisted = false,
          buftype = "acwrite",
          expandtab = true,
          shiftwidth = 2,
        },
        kind = "replace",
        kinds = {
          float = {
            height = "70%",
            width = "70%",
            top = "10%",
            left = "15%",
          },
          replace = {},
          split_above = {
            height = "70%",
          },
          split_above_all = {
            height = "70%",
            win_opts = {
              winfixheight = true, -- Fixed height.
            },
          },
          split_below = {
            height = "70%",
          },
          split_below_all = {
            height = "70%",
            win_opts = {
              winfixheight = true,
            },
          },
          split_left = {
            width = "70%",
          },
          split_left_most = {
            width = "20%",
            win_opts = {
              winfixwidth = true, -- Fixed width.
            },
          },
          split_right = {
            width = "30%",
          },
          split_right_most = {
            width = "30%",
            win_opts = {
              winfixwidth = true,
            },
          },
        },
        win_opts = {
          concealcursor = "nvic",
          conceallevel = 3,
          cursorline = false,
          number = false,
          relativenumber = false,
          winhighlight = "Normal:FylerNormal,NormalNC:FylerNormalNC",
          wrap = false,
        },
      },
    },
  },
})
