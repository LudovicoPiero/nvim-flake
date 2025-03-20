{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.dashboard-nvim;
  event = "VimEnter";
  config = ''
    function()
      require('dashboard').setup {}
    end
  '';
}
