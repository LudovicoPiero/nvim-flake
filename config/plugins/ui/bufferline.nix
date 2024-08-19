{
  plugins.bufferline = {
    enable = true;
    settings.options = {
      diagnostics = "nvim_lsp";
      offsets = [
        {
          filetype = "CHADTree";
          highlight = "Directory";
          text = "File Explorer";
          text_align = "center";
        }
      ];
    };
  };
}
