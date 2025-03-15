{
  config = {
    autoCmd = [
      {
        # Automatically reload files changed outside Neovim
        event = [
          "FocusGained"
          "BufEnter"
        ];
        pattern = [ "*" ];
        command = "checktime";
      }
      {
        # Remove trailing whitespace before saving
        event = [ "BufWritePre" ];
        pattern = [ "*" ];
        command = "%s/\\s\\+$//e";
      }
      {
        # Auto-insert text for Git commit messages
        event = [ "FileType" ];
        pattern = [ "gitcommit" ];
        command = ''
          " Start the commit message with a bullet point for convention
          if line("$") == 1 && getline(1) == ""
            call append(0, "- ")
            normal! G
          endif
        '';
      }
      {
        # Disable line numbers and enable spellcheck for Git commit messages
        event = [ "FileType" ];
        pattern = [ "gitcommit" ];
        command = "setlocal nonumber norelativenumber spell";
      }
      {
        # Highlight when yanking (copying) text
        event = [ "TextYankPost" ];
        pattern = [ "*" ];
        command = ''
          lua << EOF
          vim.highlight.on_yank()
          EOF
        '';
      }
    ];
  };
}
