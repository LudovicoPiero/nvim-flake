{
  plugins.notify = {
    enable = true;
    settings = {
      timeout = 3000;
      background_colour = "#000000";
      max_height = {
        __raw = "math.floor(vim.o.lines * 0.75)";
      };
      max_width = {
        __raw = "math.floor(vim.o.columns * 0.75)";
      };
      on_open = ''
        function(win)
          vim.api.nvim_win_set_config(win, { zindex = 100 })
        end
      '';
    };
  };
}
