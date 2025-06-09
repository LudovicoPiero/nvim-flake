{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.lualine-nvim;
  lazy = false;
  dependencies = with pkgs.vimPlugins; [ nvim-web-devicons ];
  opts.__raw = ''
    {  }
  '';
}
