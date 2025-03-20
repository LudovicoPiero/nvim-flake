{ pkgs, helpers, ... }:
{
  pkg = pkgs.vimPlugins.gitsigns-nvim;
  opts = helpers.mkRaw ''
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
