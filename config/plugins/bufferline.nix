{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.bufferline-nvim;
  lazy = false;
  dependencies = with pkgs.vimPlugins; [ nvim-web-devicons ];
  init = ''
    function()
      vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true })

      vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { silent = true })
    end
  '';
  config = ''
    function()
      local bufferline = require('bufferline')
      bufferline.setup {
        highlights = require("catppuccin.groups.integrations.bufferline").get(),
        options = {
          show_close_icon = false,
          show_buffer_close_icons = false,
          separator_style = "thin",
          diagnostics = "nvim_lsp",
          themable = true,
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              text_align = "Directory",
              separator = true
            }
          },
          pick = {
            alphabet = "abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ1234567890",
          },

        },
      }
    end
  '';
}
