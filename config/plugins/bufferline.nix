{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.bufferline-nvim;
  lazy = false;
  dependencies = with pkgs.vimPlugins; [ nvim-web-devicons ];
  config = ''
    function()
      require("bufferline").setup {
        highlights = require("catppuccin.groups.integrations.bufferline").get()
      }
    end
  '';
}
