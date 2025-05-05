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
  ];
}
