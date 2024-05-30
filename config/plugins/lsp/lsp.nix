{ lib, pkgs, ... }:
{
  plugins = {
    lsp-lines.enable = true;

    luasnip = {
      enable = true;
      extraConfig = {
        history = true;
        delete_check_events = "TextChanged";
        fromVscode = [ { lazyLoad = true; } ];
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
          virtual_text = false,
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

        csharp-ls = {
          enable = true;
          filetypes = [ "cs" ];
        };

        dockerls = {
          enable = true;
          filetypes = [ "dockerfile" ];
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
          filetypes = [ "py" ];
        };

        html = {
          enable = true;
          filetypes = [ "html" ];
        };

        cssls = {
          enable = true;
          filetypes = [ "css" ];
        };

        tsserver = {
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

        lua-ls = {
          enable = true;
          filetypes = [ "lua" ];
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
          filetypes = [ "nix" ];
        };

        gopls = {
          enable = true;
          filetypes = [ "go" ];
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

        rust-analyzer = {
          enable = true;
          filetypes = [ "rs" ];
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

  keymaps = [
    {
      mode = "n";
      key = "K";
      action = "<cmd>lua vim.lsp.buf.hover()<CR>";
      options = {
        silent = true;
        desc = "Hover Documentation";
      };
    }
    {
      mode = "n";
      key = "gD";
      action = "<cmd>lua vim.lsp.buf.declaration()<CR>";
      options = {
        silent = true;
        desc = "[G]oto [D]eclaration";
      };
    }
    {
      mode = "n";
      key = "gd";
      action = "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>";
      options = {
        silent = true;
        desc = "[G]oto [D]efinition";
      };
    }
    {
      mode = "n";
      key = "gr";
      action = "<cmd>lua require('telescope.builtin').lsp_references()<CR>";
      options = {
        silent = true;
        desc = "[G]oto [R]eferences";
      };
    }
    {
      mode = "n";
      key = "gI";
      action = "<cmd>lua require('telescope.builtin').lsp_implementations()<CR>";
      options = {
        silent = true;
        desc = "[G]oto [I]mplementation";
      };
    }
    {
      mode = "n";
      key = "<leader>rn";
      action = "<cmd>lua vim.lsp.buf.rename()<CR>";
      options = {
        silent = true;
        desc = "[R]e[n]ame";
      };
    }
    {
      mode = "n";
      key = "<leader>D";
      action = "<cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>";
      options = {
        silent = true;
        desc = "Type [D]efinition";
      };
    }
    {
      mode = "n";
      key = "<leader>ds";
      action = "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>";
      options = {
        silent = true;
        desc = "[D]ocument [S]ymbols";
      };
    }
    {
      mode = "n";
      key = "<leader>ws";
      action = "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>";
      options = {
        silent = true;
        desc = "[W]orkspace [S]ymbols";
      };
    }
    {
      mode = "n";
      key = "<leader>wa";
      action = "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>";
      options = {
        silent = true;
        desc = "[W]orkspace [A]dd Folder";
      };
    }
    {
      mode = "n";
      key = "<leader>wr";
      action = "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>";
      options = {
        silent = true;
        desc = "[W]orkspace [R]emove Folder";
      };
    }
    {
      mode = "n";
      key = "<leader>wl";
      action = "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>";
      options = {
        silent = true;
        desc = "[W]orkspace [L]ist Folders";
      };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<cmd>lua vim.lsp.buf.signature_help()<CR>";
      options = {
        silent = true;
        desc = "Signature Documentation";
      };
    }
  ];
}
