local function augroup(name)
  return vim.api.nvim_create_augroup("lain_" .. name, { clear = true })
end

-- Highlight yanked text.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  desc = "Highlight yanked text",
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- Close certain filetypes with 'q'.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "help",
    "qf",
    "man",
    "notify",
    "checkhealth",
    "lspinfo",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
    "gitsigns.blame",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Open help in a vertical split.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("help_split"),
  pattern = "help",
  command = "wincmd L",
})

-- Set filetype for dotfiles.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("filetype_settings"),
  pattern = { ".env", ".env.*" },
  callback = function()
    vim.bo.filetype = "sh"
  end,
})

-- Clear LSP references in insert mode.
-- Avoids sticky reference highlighting.
vim.api.nvim_create_autocmd("CursorMovedI", {
  group = augroup("clear_lsp_refs"),
  callback = function()
    vim.lsp.buf.clear_references()
  end,
})

-- Trim trailing whitespace on save.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("trim_whitespace"),
  pattern = "*",
  callback = function()
    -- Skip for markdown and binary files.
    if vim.bo.filetype == "markdown" or vim.bo.binary then
      return
    end

    local save = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- Resize splits on window resize.
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

local refresh_group = vim.api.nvim_create_augroup("AutoRefreshFile", { clear = true })
-- Force Neovim to check if the file changed on disk when you switch focus or buffers
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = refresh_group,
  callback = function()
    if vim.o.buftype == "" and not vim.api.nvim_buf_get_name(0):match("^%w+://") then
      vim.cmd("checktime")
    end
  end,
})
-- Notify the post-reload event cleanly
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = refresh_group,
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded automatically.", vim.log.levels.WARN)
  end,
})
