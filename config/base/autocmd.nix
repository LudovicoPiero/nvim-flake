{
  autoGroups = {
    highlightyank.clear = true;
    q_close_windows.clear = true;
  };

  autoCmd = [
    {
      desc = "Highlight when yanking (copying) text";
      event = [ "TextYankPost" ];
      group = "highlightyank";
      pattern = [ "*" ];
      callback.__raw = ''
        function()
          vim.highlight.on_yank()
        end
      '';
    }
    {
      # Automatically remove trailing whitespace before saving the file
      event = [ "BufWritePre" ];
      pattern = [ "*" ];
      command = "%s/\\s\\+$//e";
    }
    {
      desc = "Make q close help, man, quickfix, dap floats";
      event = "BufWinEnter";
      group = "q_close_windows";

      callback.__raw = ''
        function(event)
          if vim.tbl_contains({ "help", "nofile", "quickfix" }, vim.bo[event.buf].buftype) then
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
