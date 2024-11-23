{
  pkgs,
  self,
  ...
}: {
  plugins = {
    lsp-lines = {
      enable = true;
      luaConfig.post = ''
        vim.diagnostic.config({
          virtual_lines = { only_current_line = true },
          virtual_text = false,
        })
      '';
    };

    lspsaga = {
      enable = true;
      lightbulb.sign = false;
      symbolInWinbar.enable = false;
      ui.border = "rounded";
    };

    luasnip = {
      enable = true;
      fromVscode = [{paths = "${pkgs.vimPlugins.friendly-snippets}";}];
      settings = {
        history = true;
        delete_check_events = "TextChanged";
      };
    };

    lspkind = {
      enable = true;

      cmp = {
        enable = true;

        menu = {
          buffer = "[Buffer]";
          calc = "[Calc]";
          cmdline = "[Cmdline]";
          codeium = "[Codeium]";
          emoji = "[Emoji]";
          git = "[Git]";
          luasnip = "[Snippet]";
          neorg = "[Neorg]";
          nvim_lsp = "[LSP]";
          nvim_lua = "[API]";
          path = "[Path]";
          spell = "[Spell]";
          treesitter = "[TreeSitter]";
        };
      };
    };

    lsp = {
      enable = true;

      preConfig = ''
        -- add additional capabilities supported by nvim-cmp
        -- nvim has not added foldingRange to default capabilities, users must add it manually
        local capabilities = vim.tbl_deep_extend(
          "force",
          vim.lsp.protocol.make_client_capabilities(),
          require("cmp_nvim_lsp").default_capabilities(),
          -- File watching is disabled by default for neovim.
          -- See: https://github.com/neovim/neovim/pull/22405
          { workspace = { didChangeWatchedFiles = { dynamicRegistration = true } } }
        )
        capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        }
      '';

      postConfig = ''
        -- Change diagnostic symbols in the sign column (gutter)
        local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
        for type, icon in pairs(signs) do
          local hl = "DiagnosticSign" .. type
          vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end
        vim.diagnostic.config({
          signs = true,
          underline = true,
          update_in_insert = true,
          severity_sort = false,
        })
      '';

      servers = {
        ccls = {
          enable = true;
          filetypes = [
            "c"
            "cpp"
            "objc"
            "objcpp"
          ];

          initOptions.compilationDatabaseDirectory = "out/release";
        };

        csharp_ls = {
          enable = true;
          filetypes = ["cs"];
        };

        dockerls = {
          enable = true;
          filetypes = ["dockerfile"];
        };

        bashls = {
          enable = true;
          filetypes = [
            "sh"
            "bash"
          ];
        };

        pyright = {
          enable = true;
          filetypes = ["py"];
        };

        html = {
          enable = true;
          filetypes = ["html"];
        };

        cssls = {
          enable = true;
          filetypes = ["css"];
        };

        ts_ls = {
          enable = true;
          filetypes = [
            "ts"
            "tsx"
            "javascript"
            "javascriptreact"
            "typescript"
            "typescriptreact"
          ];
        };

        lua_ls = {
          enable = true;
          filetypes = ["lua"];
          extraOptions = {
            settings = {
              Lua = {
                completion = {
                  callSnippet = "Replace";
                };
                telemetry = {
                  enabled = false;
                };
                hint = {
                  enable = true;
                };
              };
            };
          };
        };

        nixd = {
          enable = true;
          filetypes = ["nix"];
          settings = let
            getFlake = ''(builtins.getFlake "${self}")'';
          in {
            diagnostic.suppress = [
              "sema-escaping-with"
              "var-bind-to=this"
            ];
            formatting.command = ["${pkgs.alejandra}/bin/alejandra"];
            "nixpkgs" = {
              "expr" = "import ${getFlake}.inputs.nixpkgs { }   ";
            };
            options = {
              nixos.expr = ''${getFlake}.nixosConfigurations.sforza.options'';
              nixvim.expr = ''${getFlake}.packages.${pkgs.system}.nvim.options'';
              home-manager.expr = ''${getFlake}.homeConfigurations."airi@sforza".options'';
              flake-parts.expr = ''let flake = ${getFlake}; in flake.debug.options // flake.currentSystem.options'';
            };
          };
        };

        gopls = {
          enable = true;
          filetypes = ["go"];
          extraOptions = {
            settings = {
              experimentalPostfixCompletions = true;
              analyses = {
                unusedparams = true;
                shadow = true;
              };
              staticcheck = true;
            };
            init_options = {
              usePlaceholders = true;
            };
          };
        };

        rust_analyzer = {
          enable = true;
          filetypes = ["rs"];
          installCargo = true;
          installRustc = true;

          settings = {
            diagnostics = {
              enable = true;
              # experimental.enable = true;
              styleLints.enable = true;
            };

            files = {
              excludeDirs = [
                ".direnv"
                "rust/.direnv"
              ];
            };

            inlayHints = {
              bindingModeHints.enable = true;
              closureStyle = "rust_analyzer";
              closureReturnTypeHints.enable = "always";
              discriminantHints.enable = "always";
              expressionAdjustmentHints.enable = "always";
              implicitDrops.enable = true;
              lifetimeElisionHints.enable = "always";
              rangeExclusiveHints.enable = true;
            };

            procMacro = {
              enable = true;
            };
          };
        };
      };
    };
  };

  keymaps = let
    options = desc: {
      silent = true;
      noremap = true;
      desc = desc;
    };
  in [
    {
      action = "<CMD>Lspsaga code_action<CR>";
      key = "<leader>la";
      mode = "n";
      options = options "Code action";
    }
    {
      action = "<CMD>Lspsaga goto_definition<CR>";
      key = "<leader>ld";
      mode = "n";
      options = options "Go to definition";
    }
    {
      action = "<CMD>Lspsaga goto_type_definition<CR>";
      key = "<leader>lt";
      mode = "n";
      options = options "Go to type definition";
    }
    {
      action = "<CMD>Lspsaga diagnostic_jump_next<CR>";
      key = "<leader>ll";
      mode = "n";
      options = options "Next diagnostic";
    }
    {
      action = "<CMD>Lspsaga diagnostic_jump_prev<CR>";
      key = "<leader>lh";
      mode = "n";
      options = options "Previous diagnostic";
    }
    {
      action = "<CMD>Lspsaga finder<CR>";
      key = "<leader>lr";
      mode = "n";
      options = options "Show references and implementations";
    }
    {
      action = "<CMD>Lspsaga hover_doc<CR>";
      key = "<leader>lk";
      mode = "n";
      options = options "Hover documentation";
    }
    {
      action = "<CMD>Lspsaga outline<CR>";
      key = "<leader>lo";
      mode = "n";
      options = options "Outline";
    }
    {
      action = "<CMD>Lspsaga rename<CR>";
      key = "<leader>lc";
      mode = "n";
      options = options "Rename";
    }
  ];
}
