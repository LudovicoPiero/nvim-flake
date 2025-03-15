{
  plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native.enable = true;
      ui-select.enable = true;
    };

    settings = {
      extensions = {
        __raw = "{ ['ui-select'] = { require('telescope.themes').get_dropdown() } }";
      };
    };

    luaConfig.pre = ''
      local builtin = require 'telescope.builtin'
    '';

    keymaps = {
      "<leader>sh" = {
        action = "help_tags";
        options = {
          desc = "[S]earch [H]elp";
        };
      };
      "<leader>sk" = {
        action = "keymaps";
        options = {
          desc = "[S]earch [K]eymaps";
        };
      };
      "<leader>sf" = {
        action = "find_files";
        options = {
          desc = "[S]earch [F]iles";
        };
      };
      "<leader>ss" = {
        action = "builtin";
        options = {
          desc = "[S]earch [S]elect Telescope";
        };
      };
      "<leader>sw" = {
        action = "grep_string";
        options = {
          desc = "[S]earch current [W]ord";
        };
      };
      "<leader>sg" = {
        action = "live_grep";
        options = {
          desc = "[S]earch by [G]rep";
        };
      };
      "<leader>sd" = {
        action = "diagnostics";
        options = {
          desc = "[S]earch [D]iagnostics";
        };
      };
      "<leader>sr" = {
        action = "resume";
        options = {
          desc = "[S]earch [R]esume";
        };
      };
      "<leader>s." = {
        action = "oldfiles";
        options = {
          desc = "[S]earch Recent Files ('.' for repeat)";
        };
      };
      "<leader><leader>" = {
        action = "buffers";
        options = {
          desc = "[ ] Find existing buffers";
        };
      };
    };

    luaConfig.post = ''
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
    '';
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
      key = "<leader>/";
      action.__raw = ''
        function()
          require('telescope.builtin').current_buffer_fuzzy_find(
            require('telescope.themes').get_dropdown {
              winblend = 10,
              previewer = false
            })
        end
      '';
      options = {
        desc = "[/] Fuzzily search in current buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>s/";
      action.__raw = ''
        function()
          require('telescope.builtin').live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files'
          }
        end
      '';
      options = {
        desc = "[S]earch [/] in Open Files";
      };
    }
    {
      mode = "n";
      key = "<leader>sn";
      action.__raw = ''
        function()
          require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
        end
      '';
      options = {
        desc = "[S]earch [N]eovim files";
      };
    }
  ];
}
