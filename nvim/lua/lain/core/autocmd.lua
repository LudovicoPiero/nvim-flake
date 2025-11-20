--- Auto-commands ---
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Auto-close help, quickfix, etc. with 'q'
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "help",
    "qf",
    "lspinfo",
    "man",
    "checkhealth",
    "notify",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<CMD>close<CR>", {
      buffer = event.buf,
      silent = true,
      desc = "Close window",
    })
  end,
})

-- auto-create missing dirs when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Auto-create missing dirs when saving a file",
  group = vim.api.nvim_create_augroup("kickstart-auto-create-dir", { clear = true }),
  pattern = "*",
  callback = function()
    local dir = vim.fn.expand("<afile>:p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- Restore cursor position on file open
vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Restore cursor position on file open",
  group = vim.api.nvim_create_augroup("kickstart-restore-cursor", { clear = true }),
  pattern = "*",
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 1 and line <= vim.fn.line("$") then
      vim.cmd("normal! g'\"")
    end
  end,
})

-- open help in vertical split
vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  command = "wincmd L",
})

-- syntax highlighting for dotenv files
vim.api.nvim_create_autocmd("BufRead", {
  group = vim.api.nvim_create_augroup("dotenv_ft", { clear = true }),
  pattern = { ".env", ".env.*" },
  callback = function()
    vim.bo.filetype = "dosini"
  end,
})

-- IDE like highlight when stopping cursor
vim.api.nvim_create_autocmd("CursorMovedI", {
  group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true }),
  desc = "Clear highlights when entering insert mode",
  callback = function()
    vim.lsp.buf.clear_references()
  end,
})

--- Remove whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("TrimWhitespace", { clear = true }),
  pattern = "*", -- Apply to all file types
  callback = function()
    -- Save cursor position to restore later
    local curpos = vim.api.nvim_win_get_cursor(0)
    -- Remove trailing whitespaces
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    -- Restore cursor position
    vim.api.nvim_win_set_cursor(0, curpos)
  end,
  desc = "Trim trailing whitespace before saving",
})
