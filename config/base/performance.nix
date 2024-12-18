{
  config = {
    performance = {
      combinePlugins = {
        enable = true;
        standalonePlugins = ["nvim-treesitter"];
        pathsToLink = ["/copilot"];
      };
      byteCompileLua.enable = true;
    };
  };
}
