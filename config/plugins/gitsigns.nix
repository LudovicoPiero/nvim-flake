{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.gitsigns-nvim;
  opts.__raw = ''
    {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    }
  '';
}
