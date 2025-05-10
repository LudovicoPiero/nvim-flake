{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.todo-comments-nvim;
  dependencies = [ pkgs.vimPlugins.plenary-nvim ];
  opts.__raw = ''
    { }
  '';
}
