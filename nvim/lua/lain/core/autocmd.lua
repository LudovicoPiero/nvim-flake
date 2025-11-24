local function augroup(name)
  return vim.api.nvim_create_augroup("lain_" .. name, { clear = true })
end

-- Highlight on Yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  desc = "Highlight yanked text",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 40 })
  end,
})

-- Close specific windows with 'q'
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

-- Auto-create directories on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end

    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Open Help in vertical split (Right side)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("help_split"),
  pattern = "help",
  command = "wincmd L",
})

-- Syntax highlighting for dotfiles
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("filetype_settings"),
  pattern = { ".env", ".env.*" },
  callback = function()
    vim.bo.filetype = "sh"
  end,
})

-- Clear LSP references in Insert Mode
-- (Prevents the highlighted word from sticking when you start typing)
vim.api.nvim_create_autocmd("CursorMovedI", {
  group = augroup("clear_lsp_refs"),
  callback = function()
    vim.lsp.buf.clear_references()
  end,
})

-- Trim Whitespace on Save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("trim_whitespace"),
  pattern = "*",
  callback = function()
    -- Skip for markdown (trailing spaces signify line break) and binary files
    if vim.bo.filetype == "markdown" or vim.bo.binary then
      return
    end

    local save = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})
