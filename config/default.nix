{
  pkgs,
  helpers,
  lib,
  self,
  ...
}:
let
  # Directory containing all plugin definitions
  pluginDir = ./plugins;

  # Get all files in the directory (as an attribute set)
  pluginFiles = builtins.attrNames (builtins.readDir pluginDir);

  # Filter to include only .nix files
  nixFiles = builtins.filter (name: builtins.match ".*\\.nix" name != null) pluginFiles;

  # Import each .nix file dynamically, assuming it returns a single attribute set
  loadPlugins = map (
    file:
    import (pluginDir + "/${file}") {
      inherit
        pkgs
        helpers
        lib
        self
        ;
    }
  ) nixFiles;
in
{
  imports = [ ./base ];

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
