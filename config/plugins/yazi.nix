{ pkgs, helpers, ... }:
{
  pkg = pkgs.vimPlugins.yazi-nvim;
  lazy = false;
  dependencies = with pkgs.vimPlugins; [
    fzf-lua # for search grep
    grug-far-nvim # for find and replace
    {
      pkg = snacks-nvim;
      lazy = false;
      priority = 1000;
      opts = { };
    }
  ];
  keys = helpers.mkRaw ''
    {
      {
        "<leader>tf",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        -- Open in the current working directory
        "<leader>tw",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        "<leader>ty",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    }
  '';
  opts = helpers.mkRaw ''
    {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = true,
      keymaps = {
        show_help = "<f1>",
      },
    }
  '';
  init = ''
    function()
      -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end
  '';
}
