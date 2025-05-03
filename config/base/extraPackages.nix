{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    bat
    fzf
    ripgrep
  ];
}
