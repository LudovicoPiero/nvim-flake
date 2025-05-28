{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.guess-indent-nvim;
  opts.__raw = ''
    {  }
  '';
}
