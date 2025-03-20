{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.mini-nvim;
  config = ''
    function()
      require('mini.ai').setup { n_lines = 500 }

      require('mini.splitjoin').setup()

      require('mini.bufremove').setup()
      require('mini.starter').setup()
    end
  '';
}
