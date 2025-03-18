{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.nvim-notify;
  event = [
    "BufReadPost"
    "BufNewFile"
    "BufWritePre"
  ];
  config = ''
    function()
      require("notify").setup({
        background_colour = "#000000",
        max_height = math.floor(vim.o.lines * 0.75),
        max_width = math.floor(vim.o.columns * 0.75),
        on_open = function(win)
            vim.api.nvim_win_set_config(win, { zindex = 100 })
        end,
        timeout = 3000,
      })
    end
  '';
}
