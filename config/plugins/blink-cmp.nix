{
  pkgs,
  helpers,
  ...
}:
{
  pkg = pkgs.vimPlugins.blink-cmp;
  event = [
    "InsertEnter"
    "CmdlineEnter"
  ];
  dependencies = with pkgs.vimPlugins; [
    blink-cmp-copilot
    blink-cmp-conventional-commits
    blink-nerdfont-nvim
    cmp-calc
    friendly-snippets
    lazydev-nvim
    lspkind-nvim
    luasnip
    {
      pkg = blink-compat;
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
            copilot_node_command = "${pkgs.nodejs_latest}/bin/node",
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

  opts = helpers.mkRaw ''
    {
      cmdline = { enabled = false },
      keymap = {
        preset = "default",
      },

      appearance = {
        nerd_font_variant = "mono",
        use_nvim_cmp_as_default = true,
        kind_icons = {
          Copilot = "",
        },
      },

      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        ghost_text = { enabled = true },
        menu = {
          auto_show = true,
          border = "rounded",
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind" },
            },
            components = {
              kind_icon = {
                text = function(ctx)
                  local lspkind = require("lspkind")
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  else
                    icon = lspkind.symbolic(ctx.kind, {
                      mode = "symbol",
                    })
                  end

                  return icon .. ctx.icon_gap
                end,

                -- Optionally, use the highlight groups from nvim-web-devicons
                -- You can also add the same function for `kind.highlight` if you want to
                -- keep the highlight groups in sync with the icons.
                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              },
            },
          },
        },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer", "calc", "copilot", "lazydev", "conventional_commits", "nerdfont" },
        providers = {
          lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
          conventional_commits = {
            module = "blink-cmp-conventional-commits",
            name = "Conventional Commits",
            enabled = function()
              return vim.bo.filetype == "gitcommit"
            end,
            opts = {},
          },
          nerdfont = {
            module = "blink-nerdfont",
            name = "Nerd Fonts",
            score_offset = 15, -- Tune by preference
            opts = { insert = true }, -- Insert nerdfont icon (default) or complete its name
          },
          buffer = {
            min_keyword_length = function()
              return vim.bo.filetype == "markdown" and 0 or 1
            end,
          },
          lsp = { score_offset = 4 },
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

      snippets = { preset = "luasnip" },

      fuzzy = {
        implementation = "rust",
        prebuilt_binaries = {
          download = false,
        },
      },

      signature = {
        enabled = true,
        window = { border = "rounded" },
      },
    }
  '';

}
