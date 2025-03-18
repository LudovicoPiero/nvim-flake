{
  performance = {
    combinePlugins = {
      enable = true;
      standalonePlugins = [
        "mini.nvim"
        "nvim-treesitter"
        "nvim-config"
      ];
      pathsToLink = [
        "/build"
        "/copilot"
      ];
    };
    byteCompileLua.enable = true;
  };
}
