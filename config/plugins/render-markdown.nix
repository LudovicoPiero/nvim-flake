{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.render-markdown-nvim;
  dependencies = [ pkgs.vimPlugins.nvim-web-devicons ];
  opts.__raw = ''
    {  }
  '';
}
