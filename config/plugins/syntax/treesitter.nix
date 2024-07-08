{
  plugins.treesitter = {
    enable = true;

    nixGrammars = true;
    nixvimInjections = true;
    folding = false;

    settings = {
      # ignoreInstall = [ ];
      # ensure_installed = [ "all" ];
      indent.enable = true;
    };
  };
}
