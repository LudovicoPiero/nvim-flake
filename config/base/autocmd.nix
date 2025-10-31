{
  autoGroups = {
    highlightyank.clear = true;
    q_close_windows.clear = true;
    auto_create_dir.clear = true;
    wrap_spell.clear = true;
    man_unlisted.clear = true;
  };

  autoCmd = [
    {
      desc = "Highlight when yanking (copying) text";
      event = [ "TextYankPost" ];
      group = "highlightyank";
      pattern = [ "*" ];
      callback.__raw = ''
        function()
          vim.hl.on_yank()
        end
      '';
    }
    {
      desc = "Automatically remove trailing whitespace before saving the file";
      event = [ "BufWritePre" ];
      pattern = [ "*" ];
      command = "%s/\\s\\+$//e";
    }
    {
      desc = "Auto create dir when saving a file, in case some intermediate directory does not exist";
      event = [ "BufWritePre" ];
      group = "auto_create_dir";
      callback.__raw = ''
        function(event)
          if event.match:match("^%w%w+:[\\/][\\/]") then
            return
          end
          local file = vim.uv.fs_realpath(event.match) or event.match
          vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
        end
      '';
    }
    {
      desc = "Wrap and check for spell in text filetypes";
      event = [ "FileType" ];
      group = "wrap_spell";
      pattern = [
        "text"
        "plaintext"
        "typst"
        "gitcommit"
        "markdown"
      ];
      callback.__raw = ''
        function()
          vim.opt_local.wrap = true
          vim.opt_local.spell = true
        end
      '';
    }
    {
      desc = "Make it easier to close man-files when opened inline";
      event = [ "FileType" ];
      group = "man_unlisted";
      pattern = [ "man" ];
      callback.__raw = ''
        function(event)
          vim.bo[event.buf].buflisted = false
        end
      '';
    }
    {
      desc = "Make q close help, man, quickfix, dap floats";
      event = "BufWinEnter";
      group = "q_close_windows";
      callback.__raw = ''
        function(event)
          if vim.tbl_contains({ "help", "nofile", "quickfix", "grug-far", "lspinfo", "notify", "startuptime", "checkhealth" }, vim.bo[event.buf].buftype) then
            vim.keymap.set("n", "q", "<Cmd>close<CR>", {
              desc = "Close window",
              buffer = event.buf,
              silent = true,
              nowait = true,
            })
          end
        end
      '';
    }
  ];
}
