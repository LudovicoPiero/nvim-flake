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

    # Move focus between windows
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w><C-h>";
      options.desc = "Move focus to the left window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w><C-l>";
      options.desc = "Move focus to the right window";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w><C-j>";
      options.desc = "Move focus to the lower window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w><C-k>";
      options.desc = "Move focus to the upper window";
    }

    # For mini.nvim
    {
      action.__raw = ''
        function()
          vim.g.minipairs_disable = not vim.g.minipairs_disable
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
  ];
}
