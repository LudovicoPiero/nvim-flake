{ pkgs, helpers, ... }:
{
  pkg = pkgs.vimPlugins.todo-comments-nvim;
  event = "VimEnter";
  dependencies = [ pkgs.vimPlugins.plenary-nvim ];
  opts = helpers.mkRaw ''
    { signs = false }
  '';
}
