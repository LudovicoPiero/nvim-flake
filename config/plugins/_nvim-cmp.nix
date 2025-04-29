# Source: https://github.com/Ruixi-rebirth/nvim-flake/blob/68ffe64e325d082504aeee93451fabece55df19f/config/lazy_plugins/nvim-cmp.nix
{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.nvim-cmp;
  lazy = false;
  event = "InsertEnter";
  dependencies = with pkgs.vimPlugins; [
    lspkind-nvim
    cmp-nvim-lsp
    cmp-buffer
    cmp_luasnip
    cmp-nvim-lua
    cmp-path
    cmp-cmdline
    cmp-rg
    cmp-calc
    {
      pkg = pkgs.vimPlugins.luasnip;
      dependencies = [ pkgs.vimPlugins.friendly-snippets ];
    }
    {
      pkg = pkgs.vimPlugins.copilot-cmp;
      dependencies = [
        {
          pkg = pkgs.vimPlugins.copilot-lua;
          cmd = "Copilot";
          event = "InsertEnter";
          config = ''
            function()
              require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
                copilot_node_command = "${pkgs.nodejs_latest}/bin/node",
              })
            end
          '';
        }
      ];
      config = ''
        function()
          require("copilot_cmp").setup({
            event = { "InsertEnter", "LspAttach" },
            fix_pairs = true,
          })
        end
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

      local kind_icons = {
        Text = "󰊄",
        Method = "",
        Function = "󰡱",
        Constructor = "",
        Field = "",
        Variable = "󱀍",
        Class = "",
        Interface = "",
        Module = "󰕳",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
        Copilot = "",
      }
      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
      -- find more here: https://www.nerdfonts.com/cheat-sheet

      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
          return false
        end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
      end

      cmp.setup({
          completion = { completeopt = "menu,menuone,noselect" },
          experimental = { ghost_text = { hl_group = "CmpGhostText" } },
          formatting = {
              format = require("lspkind").cmp_format({
                  ellipsis_char = "...",
                  maxwidth = 50,
                  symbol_map = { Copilot = "" },
              }),
          },
          mapping = {
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<C-d>"] = cmp.mapping.scroll_docs(-4),
              ["<C-e>"] = cmp.mapping.close(),
              ["<C-f>"] = cmp.mapping.scroll_docs(4),
              ["<C-h>"] = cmp.mapping(function()
                  if require("luasnip").locally_jumpable(-1) then
                      require("luasnip").jump(-1)
                  end
              end, { "i", "s" }),
              ["<C-l>"] = cmp.mapping(function()
                  if require("luasnip").expand_or_locally_jumpable() then
                      require("luasnip").expand_or_jump()
                  end
              end, { "i", "s" }),
              ["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
              ["<S-Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                      cmp.select_prev_item()
                  elseif require("luasnip").jumpable(-1) then
                      require("luasnip").jump(-1)
                  else
                      fallback()
                  end
              end, { "i", "s" }),
              ["<Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() and has_words_before() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                  elseif require("luasnip").expand_or_jumpable() then
                      require("luasnip").expand_or_jump()
                  else
                    fallback()
                  end
              end, { "i", "s" }),
          },
          snippet = {
              expand = function(args)
                  require("luasnip").lsp_expand(args.body)
              end,
          },
          sources = {
              -- Copilot.lua
              { name = "copilot", group_index = 2 },
              -- Other Sources
              { name = "nvim_lsp", group_index = 2 },
              { name = "nvim_lua", group_index = 2 },
              { name = "path", group_index = 2 },
              { name = "luasnip", group_index = 2 },
              { name = "buffer", group_index = 2 },
              { name = "calc", group_index = 2 },
              { name = "rg", group_index = 2 },
              { name = "emoji", group_index = 2 },
              { name = "cmdli", group_index = 2 },
          },
      })

      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
      })
    end
  '';
}
