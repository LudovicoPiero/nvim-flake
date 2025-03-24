{
  pkgs,
  ...
}:
{
  pkg = pkgs.vimPlugins.blink-cmp;
  lazy = true;
  event = "InsertEnter";
  dependencies = with pkgs.vimPlugins; [
    friendly-snippets
    luasnip
    cmp-calc
    {
      pkg = blink-compat;
      lazy = true;
      opts = { };
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
                suggestion = {
                  enabled = true,
                  auto_trigger = false,
                  hide_during_completion = true,
                  keymap = {
                    accept = "<C-cr>",
                  },
                },
                panel = { enabled = false },
                copilot_node_command = "${pkgs.nodejs-18_x}/bin/node",
                filetypes = { ["*"] = true, },
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

      require("blink.cmp").setup({
        cmdline = {
          enabled = true,
          keymap = nil,
          completion={
            list = {
              selection = {
                preselect = false,
                auto_insert = true
              },
            },
            menu = { auto_show = true },
            ghost_text = { enabled = false },
          },
        },
        term = {
          enabled = false,
          keymap = nil,
          completion={
            menu = { auto_show = true },
            ghost_text = { enabled = false },
            trigger = {
              show_on_blocked_trigger_characters = {},
              show_on_x_blocked_trigger_characters = nil, -- Inherits from top level `completion.trigger.show_on_blocked_trigger_characters` config when not set
            },
            -- Inherits from top level config options when not set
            list = {
              selection = {
                -- When `true`, will automatically select the first item in the completion list
                preselect = nil,
                -- When `true`, inserts the completion item automatically when selecting it
                auto_insert = nil,
              },
            },
            -- Whether to automatically show the window when new completion items are available
            menu = { auto_show = nil },
            -- Displays a preview of the selected item on the current line
            ghost_text = { enabled = nil },
          },
        },
        completion = {
          accept = {
            auto_brackets = {
              enabled = true,
            },
          },
          list = {
            selection = { preselect = true, auto_insert = true },
            cycle = {
              -- When `true`, calling `select_next` at the *bottom* of the completion list
              -- will select the *first* completion item.
              from_bottom = true,
              -- When `true`, calling `select_prev` at the *top* of the completion list
              -- will select the *last* completion item.
              from_top = true,
            },
          },
          menu = {
            enabled = true,
            border = "rounded",
            winblend = 0,
            auto_show = true,
            winhighlight = "Normal:_BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
            draw = {
              align_to = 'label',
              gap = 1,
              padding = 1,
              treesitter = { "lsp" },
              columns = {
                { "kind_icon" },
                { "label", "label_description", gap = 1 },
                { "source_name" },
              },
              components = {
                kind_icon = {
                  ellipsis = false,
                  text = function(ctx) return ctx.kind_icon .. ctx.icon_gap end,
                  highlight = function(ctx) return ctx.kind_hl end,
                },
                kind = {
                  ellipsis = false,
                  width = { fill = true },
                  text = function(ctx) return ctx.kind end,
                  highlight = function(ctx) return ctx.kind_hl end,
                },
                label = {
                  width = { fill = true, max = 60 },
                  text = function(ctx)
                    return ctx.label .. ctx.label_detail
                  end,
                  highlight = function(ctx)
                    -- label and label details
                    local highlights = {
                      { 0, #ctx.label, group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel" },
                    }
                    if ctx.label_detail then
                      table.insert(highlights, { #ctx.label, #ctx.label + #ctx.label_detail, group = "BlinkCmpLabelDetail" })
                    end

                    -- characters matched on the label by the fuzzy matcher
                    for _, idx in ipairs(ctx.label_matched_indices) do
                      table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                    end

                    return highlights
                  end,
                },
                label_description = {
                  width = { max = 30 },
                  text = function(ctx)
                    return ctx.label_description
                  end,
                  highlight = "BlinkCmpLabelDescription",
                },
                source_name = {
                  width = { fill = true, max = 30 },
                  text = function(ctx)
                    return ctx.source_name
                  end,
                  highlight = "BlinkCmpSource",
                },
                source_id = {
                  width = { max = 30 },
                  text = function(ctx) return ctx.source_id end,
                  highlight = 'BlinkCmpSource',
                },
              },
            },
          },
          keyword = {
            range = "full",
          },
          trigger = {
            prefetch_on_insert = false,
            show_on_keyword = true,
            show_in_snippet = true,
            show_on_trigger_character = true,
            show_on_insert_on_trigger_character = true,
            show_on_accept_on_trigger_character = true,
            show_on_blocked_trigger_characters = { ' ', '\n', '\t' },
            show_on_x_blocked_trigger_characters = { "'", '"', '(' },
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 100,
            update_delay_ms = 50,
            treesitter_highlighting = true,
            window = {
              border = "rounded",
              winblend = 0,
              winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
            },
          },
          ghost_text = {
            enabled = false,
            -- Show the ghost text when an item has been selected
            show_with_selection = true,
            -- Show the ghost text when no item has been selected, defaulting to the first item
            show_without_selection = false,
            -- Show the ghost text when the menu is open
            show_with_menu = true,
            -- Show the ghost text when the menu is closed
            show_without_menu = true,
          },
        },
        signature = {
          enabled = true,
          window = {
            border = "double",
            winblend = 0,
            winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
            treesitter_highlighting = true,
            show_documentation = true,
          },
          trigger = {
            blocked_trigger_characters = {},
            blocked_retrigger_characters = {},
            -- When true, will show the signature help window when the cursor comes after a trigger character when entering insert mode
            show_on_insert_on_trigger_character = true,
          },
        },
        keymap = {
          preset = none,
          ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
          ['<C-e>'] = { 'hide' },
          ['<CR>'] = { 'select_and_accept', 'fallback_to_mappings' },
          
          ['<Up>'] = { 'select_prev', 'fallback' },
          ['<Down>'] = { 'select_next', 'fallback' },
          ['<C-p>'] = { 'snippet_forward', 'fallback_to_mappings' },
          ['<C-n>'] = { 'snippet_backward', 'fallback_to_mappings' },
          
          ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
          ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
          
          ['<Tab>'] = { 'select_next', 'fallback' },
          ['<S-Tab>'] = { 'select_prev', 'fallback' },
          
          ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
        },
        snippets = {
          preset = 'luasnip', -- | default | luasnip |
        },
        sources = {
          default = { "copilot", "lsp", "path", "snippets", "cmdline", "buffer", "calc" },
          providers = {
            lsp = { score_offset = 5, },
            snippets = { score_offset = 4, },
            path = {
              opts = {
                trailing_slash = true,
                label_trailing_slash = true,
                get_cwd = function(context) return vim.fn.expand(('#%d:p:h'):format(context.bufnr)) end,
                show_hidden_files_by_default = false,
              },
            },
            cmdline = {
              enabled = function()
                return vim.fn.mode() == "c"
              end,
              name = "cmdline",
              module = "blink.cmp.sources.cmdline",
              score_offset = 5,
              transform_items = function(_, items)
                local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                local kind_idx = #CompletionItemKind + 1
                CompletionItemKind[kind_idx] = "Cmdline"
                for _, item in ipairs(items) do
                  item.kind = kind_idx
                  item.source_name = "Cmdline"
                end
                return items
              end,
            },
            copilot = {
              enabled = true,
              name = "copilot", -- same as source_name in nvim-cmp
              module = "blink.compat.source",
              score_offset = 100,
              async = true,
              transform_items = function(_, items)
                local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                local kind_idx = #CompletionItemKind + 1
                CompletionItemKind[kind_idx] = "Copilot"
                for _, item in ipairs(items) do
                  item.kind = kind_idx
                  item.source_name = "Copilot"
                end
                return items
              end,
            },
            calc = {
              enabled = true,
              name = "calc", -- same as source_name in nvim-cmp
              module = "blink.compat.source",
              async = true,
              score_offset = -5,
              transform_items = function(_, items)
                local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                local kind_idx = #CompletionItemKind + 1
                CompletionItemKind[kind_idx] = "Calc"
                for _, item in ipairs(items) do
                  item.kind = kind_idx
                  item.source_name = "Calc"
                end
                return items
              end,
            },
          },
        },
        appearance = {
          nerd_font_variant = "normal",
          kind_icons = {
            Text = '󰉿',
            Method = '󰊕',
            Function = '󰊕',
            Constructor = '󰒓',

            Field = '󰜢',
            Variable = '󰆦',
            Property = '󰖷',

            Class = '󱡠',
            Interface = '󱡠',
            Struct = '󱡠',
            Module = '󰅩',

            Unit = '󰪚',
            Value = '󰦨',
            Enum = '󰦨',
            EnumMember = '󰦨',

            Keyword = '󰻾',
            Constant = '󰏿',

            Snippet = '󱄽',
            Color = '󰏘',
            File = '󰈔',
            Reference = '󰬲',
            Folder = '󰉋',
            Event = '󱐋',
            Operator = '󰪚',
            TypeParameter = '󰬛',
          },
        },
        fuzzy = {
          implementation = 'prefer_rust_with_warning',
          prebuilt_binaries = {
            download = false,
          },
        }
      })
    end
  '';
}
