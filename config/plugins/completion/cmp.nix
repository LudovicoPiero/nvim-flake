{
  plugins = {
    cmp-buffer.enable = true;
    cmp-nvim-lua.enable = true;
    cmp-path.enable = true;
    cmp_luasnip.enable = true;
    cmp-nvim-lsp.enable = true;

    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        experimental = {
          ghost_text = false;
          native_menu = false;
        };
        mapping = {
          "<C-u>" = "cmp.mapping.scroll_docs(-4)"; # Up
          "<C-d>" = "cmp.mapping.scroll_docs(4)"; # Down
          "<C-Space>" = "cmp.mapping.complete()";
          "<CR>" = "cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })";

          "<Tab>" = ''
            cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        print("Luasnip can expand or jump!")
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" })
          '';

          "<S-Tab>" = ''
            cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                  end, { "i", "s" })
          '';
        };
        sources = [
          { name = "path"; }
          { name = "nvim_lua"; }
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "buffer"; }
        ];
        window = {
          completion = { };
          documentation = { };
        };
        snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
      };
    };
  };

  extraConfigLua = ''
    luasnip = require("luasnip")

    kind_icons = {
      Text = "󰊄 ",
      Method = " ",
      Function = "󰡱 ",
      Constructor = " ",
      Field = " ",
      Variable = "󱀍 ",
      Class = " ",
      Interface = " ",
      Module = "󰕳 ",
      Property = " ",
      Unit = " ",
      Value = " ",
      Enum = " ",
      Keyword = " ",
      Snippet = " ",
      Color = " ",
      File = " ",
      Reference = " ",
      Folder = " ",
      EnumMember = " ",
      Constant = " ",
      Struct = " ",
      Event = " ",
      Operator = " ",
      TypeParameter = " ",
    }

    local cmp = require'cmp'
    cmp.setup({
      window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
      },
    })
  '';
}
