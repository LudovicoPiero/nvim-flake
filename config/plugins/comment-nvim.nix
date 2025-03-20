{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.comment-nvim;
  config = ''
    function()
      require('Comment').setup()
    end
  '';
}
