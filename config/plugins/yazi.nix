{ pkgs, ... }:
let
  grug-far = {
    pkg = pkgs.vimPlugins.grug-far-nvim;
    opts = {
      headerMaxWidth = 80;
    };
    cmd = "GrugFar";
    keys.__raw = ''
      {
        {
          "<leader>sr",
          function()
            local grug = require("grug-far")
            local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
            grug.open({
              transient = true,
              prefills = {
                filesFilter = ext and ext ~= "" and "*." .. ext or nil,
              },
            })
          end,
          mode = { "n", "v" },
          desc = "[S]earch and [R]eplace",
        },
      }
    '';
  };
in
{
  pkg = pkgs.vimPlugins.yazi-nvim;
  event = "VeryLazy";
  dependencies = [
    pkgs.vimPlugins.fzf-lua # for search grep
    grug-far
    {
      pkg = pkgs.vimPlugins.snacks-nvim;
      lazy = false;
      priority = 1000;
      opts = { };
    }
  ];
  keys.__raw = ''
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
  opts.__raw = ''
    {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    }
  '';
}
