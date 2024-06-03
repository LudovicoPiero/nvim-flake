{ neovim-nightly-overlay, pkgs, ... }:
{
  config.package = neovim-nightly-overlay.packages.${pkgs.system}.neovim;
}
