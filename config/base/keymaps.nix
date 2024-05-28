{
  config = {
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
        key = "[d";
        action = "vim.diagnostic.goto_prev";
      }
      {
        mode = "n";
        key = "]d";
        action = "vim.diagnostic.goto_next";
      }
      {
        mode = "n";
        key = "<Space>e";
        action = "vim.diagnostic.open_float";
      }
      {
        mode = "n";
        key = "<Space>q";
        action = "vim.diagnostic.setloclist";
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
      # Move text up and down
      {
        mode = "x";
        key = "J";
        action = ":move '>+1<CR>gv-gv";
        options.silent = true;
      }
      {
        mode = "x";
        key = "K";
        action = ":move '<-2<CR>gv-gv";
        options.silent = true;
      }
      {
        mode = "v";
        key = "J";
        action = ":move '>+1<CR>gv-gv";
        options.silent = true;
      }
      {
        mode = "v";
        key = "K";
        action = ":move '<-2<CR>gv-gv";
        options.silent = true;
      }
    ];
  };
}
