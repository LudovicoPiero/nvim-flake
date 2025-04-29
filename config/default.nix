{
  pkgs,
  helpers,
  lib,
  inputs,
  ...
}:
let
  # Directory containing all plugin definitions
  pluginDir = ./plugins;

  # Get all files in the directory (as an attribute set)
  pluginFiles = builtins.attrNames (builtins.readDir pluginDir);

  # Filter to include only .nix files and exclude files starting with '_'
  nixFiles = builtins.filter (
    name: (builtins.match ".*\\.nix" name != null) && !(builtins.match "^_.*" name != null)
  ) pluginFiles;

  # Import each .nix file dynamically, assuming it returns a single attribute set
  loadPlugins = map (
    file:
    import (pluginDir + "/${file}") {
      inherit
        inputs
        pkgs
        helpers
        lib
        ;
      inherit (inputs) self;
    }
  ) nixFiles;
in
{
  imports = [ ./base ];

  package = inputs.neovim-overlay.packages.${pkgs.system}.default;

  withNodeJs = true;
  wrapRc = true;
  withPerl = true;
  withRuby = true;
  withPython3 = true;

  plugins.lazy = {
    enable = true;
    plugins = loadPlugins;
  };

  extraPackages = with pkgs; [
    yazi
  ];
}
