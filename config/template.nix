{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.bufferline-nvim;
  lazy = false;
  dependencies = with pkgs.vimPlugins; [ nvim-web-devicons ];
}
