{
  plugins.mini = {
    enable = true;
    modules = {
      ai = {
        n_lines = 500;
      };

      bufremove = {};

      comment = {
        custom_commentstring = ''
          function()
            return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
          end
        '';
      };

      pairs = {};

      statusline = {};

      surround = {
        mappings = {
          add = "gsa"; # -- Add surrounding in Normal and Visual modes
          delete = "gsd"; # -- Delete surrounding
          find = "gsf"; # -- Find surrounding (to the right)
          find_left = "gsF"; # -- Find surrounding (to the left)
          highlight = "gsh"; # -- Highlight surrounding
          replace = "gsr"; # -- Replace surrounding
          update_n_lines = "gsn"; # -- Update `n_lines`
        };
      };
    };

    luaConfig.post = ''
      -- set the section for cursor location to LINE:COLUMN
      local statusline = require 'mini.statusline'
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    '';
  };

  keymaps = [
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
