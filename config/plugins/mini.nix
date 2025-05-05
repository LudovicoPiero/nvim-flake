{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.mini-nvim;
  init = ''
    function()
      vim.keymap.set("n", "<leader>bd", function()
        local bd = require("mini.bufremove").delete
        if vim.bo.modified then
          local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
          if choice == 1 then -- Yes
            vim.cmd.write()
            bd(0)
          elseif choice == 2 then -- No
            bd(0, true)
          end
        else
          bd(0)
        end
      end, { desc = "Delete Buffer" })

      vim.keymap.set("n", "<leader>bD", function()
        require("mini.bufremove").delete(0, true)
      end, { desc = "Delete Buffer (Force)" })
    end
  '';
  config = ''
    function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.bufremove').setup()
      require('mini.splitjoin').setup()

      require('mini.surround').setup {
        mappings = {
          add = "gsa", -- Add surrounding in Normal and Visual modes
          delete = "gsd", -- Delete surrounding
          find = "gsf", -- Find surrounding (to the right)
          find_left = "gsF", -- Find surrounding (to the left)
          highlight = "gsh", -- Highlight surrounding
          replace = "gsr", -- Replace surrounding
          update_n_lines = "gsn", -- Update `n_lines`
        },
      }
    end
  '';
}
