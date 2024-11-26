{
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      disable_underline = true;
      flavour = "mocha";
      transparent_background = true;
      integrations = {
        cmp = true;
        gitsigns = true;
        mini = {
          enabled = true;
          indentscope_color = "";
        };
        notify = true;
        nvimtree = true;
        treesitter = true;
      };
      styles = {
        booleans = [
          "bold"
          "italic"
        ];
        conditionals = [
          "bold"
        ];
      };
      term_colors = true;
    };
  };
}
