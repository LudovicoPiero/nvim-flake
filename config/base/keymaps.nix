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
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
      }
      {
        mode = "";
        key = ";";
        action = ":";
      }
      {
        mode = "n";
        key = "[d";
        action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
      }
      {
        mode = "n";
        key = "]d";
        action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
      }
      {
        mode = "n";
        key = "<Space>q";
        action = "<cmd>lua vim.diagnostic.setloclist()<cr>";
        options.desc = "Open diagnostic [Q]uickfix list";
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
    ];
  };
}
