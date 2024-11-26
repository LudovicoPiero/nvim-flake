{
  plugins.bufferline = {
    enable = true;
    settings = {
      options = {
        diagnostics = "nvim_lsp";
        underline = true;
        mode = "tabs";
        offsets = [
          {
            filetype = "CHADTree";
            highlight = "Directory";
            text = "File Explorer";
            text_align = "center";
          }
          {
            filetype = "neo-tree";
            highlight = "Directory";
            text = "File Explorer";
            text_align = "center";
          }
        ];
      };
    };
    luaConfig.post = ''
      local mocha = require("catppuccin.palettes").get_palette "mocha"
      local bufferline = require("bufferline")
      bufferline.setup {
          highlights = require("catppuccin.groups.integrations.bufferline").get {
              styles = { "italic", "bold" },
              custom = {
                  all = {
                      fill = { bg = "#000000" },
                  },
                  mocha = {
                      background = { fg = mocha.text },
                  },
                  latte = {
                      background = { fg = "#000000" },
                  },
              },
          },
      }
    '';
  };
}
