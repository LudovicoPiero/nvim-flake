{
  plugins.treesitter = {
    enable = true;

    nixGrammars = true;
    nixvimInjections = true;
    folding = false;

    settings = {
      auto_install = true;
      indent.enable = true;
    };
  };
}
