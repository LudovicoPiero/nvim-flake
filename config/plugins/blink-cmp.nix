{
  pkgs,
  helpers,
  ...
}:
{
  pkg = pkgs.vimPlugins.blink-cmp;
  event = "InsertEnter";
  dependencies = with pkgs.vimPlugins; [
    blink-cmp-copilot
    friendly-snippets
    luasnip
    cmp-calc
    {
      pkg = blink-compat;
      lazy = true;
      opts = { };
    }
    {
      pkg = pkgs.vimPlugins.copilot-lua;
      cmd = "Copilot";
      event = "InsertEnter";
      opts = helpers.mkRaw ''
        {
          suggestion = {
            enabled = false,
            auto_trigger = true,
            hide_during_completion = true,
            copilot_node_command = "${pkgs.nodejs-18_x}/bin/node",
            keymap = {
              accept = false, -- handled by nvim-cmp / blink.cmp
              next = "<M-]>",
              prev = "<M-[>",
            },
          },
          panel = { enabled = false },
          filetypes = {
            gitcommit = true,
            markdown = true,
            help = true,
          },
        }
      '';
    }
  ];

  config = ''
    function()
      local cmp_status_ok, cmp = pcall(require, "cmp")
      if not cmp_status_ok then
        return
      end
      local snip_status_ok, luasnip = pcall(require, "luasnip")
      if not snip_status_ok then
        return
      end
      require("luasnip.loaders.from_vscode").lazy_load()

      local has_words_before = function()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        if col == 0 then
          return false
        end
        local line = vim.api.nvim_get_current_line():sub()
        return line:sub(col, col):match("%s") == nil
      end

      require("blink.cmp").setup({
        cmdline = { enabled = false },

        keymap = {
          preset = "super-tab",
          ['<C-y>'] = { 'select_and_accept' },

          -- preset = "none",
          -- ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
          -- ["<C-e>"] = { "hide", "fallback" },
          -- ["<CR>"] = { "accept", "fallback" },

          -- ["<Up>"] = { "select_prev", "fallback" },
          -- ["<Down>"] = { "select_next", "fallback" },
          -- ["<Tab>"] = { "select_next", "fallback" },
          -- ["<S-Tab>"] = { "select_prev", "fallback" },

          -- ["<C-b>"] = { "scroll_documentation_up", "fallback" },
          -- ["<C-f>"] = { "scroll_documentation_down", "fallback" },

          -- ["<C-p>"] = { "snippet_forward", "fallback_to_mappings" },
          -- ["<C-n>"] = { "snippet_backward", "fallback_to_mappings" },

          -- ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
        },

        completion = {
          keyword = { range = "full" },
          list = { selection = { preselect = false }, cycle = { from_top = false } },

          menu = {
            auto_show = true,

            border = "rounded";
            draw = {
              treesitter = { "lsp" },
              columns = {
                { "label", "label_description", gap = 1 },
                { "kind_icon", "kind" },
              },
            },
          },

          documentation = { auto_show = true, auto_show_delay_ms = 300 },

          ghost_text = { enabled = true },
        },

        sources = {
          default = { "lsp", "path", "snippets", "buffer", "calc", "copilot" },
          providers = {
            lsp = { score_offset = 5 },
            snippets = {
              score_offset = 4,
              opts = {
                use_show_condition = true,
                show_autosnippets = true,
              },
            },
            path = {
              score_offset = 3,
              opts = {
                trailing_slash = true,
                label_trailing_slash = true,
                get_cwd = function(context)
                  return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
                end,
                show_hidden_files_by_default = false,
              },
            },
            copilot = {
              enabled = true,
              name = "copilot",
              module = "blink-cmp-copilot",
              score_offset = 100,
              async = true,
            },
            calc = {
              enabled = true,
              name = "calc",
              module = "blink.compat.source",
              score_offset = 100,
              async = true,
            },
          },
        },

        -- Use a preset for snippets, check the snippets documentation for more information
        snippets = { preset = "luasnip" },

        -- Experimental signature help support
        signature = { enabled = true },

        fuzzy = { prebuilt_binaries = { download = false } },

        appearance = {
          -- Blink does not expose its default kind icons so you must copy them all (or set your custom ones) and add Copilot
          kind_icons = {
            Copilot = " ",
            Text = "󰉿 ",
            Method = "󰊕 ",
            Function = "󰊕 ",
            Constructor = "󰒓 ",

            Field = "󰜢 ",
            Variable = "󰆦 ",
            Property = "󰖷 ",

            Class = "󱡠 ",
            Interface = "󱡠 ",
            Struct = "󱡠 ",
            Module = "󰅩 ",

            Unit = "󰪚 ",
            Value = "󰦨 ",
            Enum = "󰦨 ",
            EnumMember = "󰦨 ",

            Keyword = "󰻾 ",
            Constant = "󰏿 ",

            Snippet = "󱄽 ",
            Color = "󰏘 ",
            File = "󰈔 ",
            Reference = "󰬲 ",
            Folder = "󰉋 ",
            Event = "󱐋 ",
            Operator = "󰪚 ",
            TypeParameter = "󰬛 ",
          },
        },
      })
    end
  '';
}
