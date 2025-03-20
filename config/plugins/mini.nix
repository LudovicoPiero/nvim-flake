{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.mini-nvim;
  config = ''
    function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.bufremove').setup()
      require('mini.splitjoin').setup()
    end
  '';
}
