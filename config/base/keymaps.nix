{
  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };

  keymaps = [
    {
      mode = "";
      key = "<Space>";
      action = "<Nop>";
      options.silent = true;
    }
    {
      mode = "";
      key = ";";
      action = ":";
    }
    {
      mode = "n";
      key = "k";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = {
        expr = true;
        silent = true;
      };
    }
    {
      mode = "n";
      key = "j";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = {
        expr = true;
        silent = true;
      };
    }

    # Taken from kickstart.nvim
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
    }
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>lua vim.diagnostic.setloclist()<cr>";
      options.desc = "Open diagnostic [Q]uickfix list";
    }

    {
      action.__raw = ''
        function()
          -- Toggle blink pairs mappings
          vim.g.blink_pairs_disabled = not vim.g.blink_pairs_disabled

          local mappings = require("blink.pairs.mappings")
          if vim.g.blink_pairs_disabled then
            mappings.disable()
          else
            mappings.enable()
          end
        end
      '';
      key = "<leader>tp";
      options.desc = "Toggle auto pairs";
    }
    {
      action.__raw = ''
        function()
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
        end
      '';
      key = "<leader>bd";
      options = {
        desc = "Delete Buffer";
      };
    }
    {
      action.__raw = ''
        function()
          require("mini.bufremove").delete(0, true)
        end
      '';
      key = "<leader>bD";
      options = {
        desc = "Delete Buffer (Force)";
      };
    }

    # Navigate between buffers
    {
      mode = "n";
      key = "<TAB>";
      action = ":bnext<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<S-TAB>";
      action = ":bprevious<CR>";
      options.silent = true;
    }
  ];
}
