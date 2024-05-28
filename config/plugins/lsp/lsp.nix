{
  plugins.cmp.enable = true;
  plugins.cmp-nvim-lsp.enable = true;
  plugins.lsp = {
    enable = true;
    onAttach = ''
      vim.api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function()
          local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded",
            source = "always",
            prefix = " ",
            scope = "line",
          }
          vim.diagnostic.open_float(nil, opts)
        end,
      })
    '';
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
      --Change diagnostic symbols in the sign column (gutter)
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
      lua-ls = {
        enable = true;
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
        settings.formatting.command = [ "nixfmt" ];
      };
      nil_ls = {
        enable = false;
        package = null;
      };
      gopls = {
        enable = true;
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
        installCargo = true;
        installRustc = true;
        onAttach.function = ''
          vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
        '';
      };
      bashls = {
        enable = true;
      };
      clangd = {
        enable = true;
      };
      pyright = {
        enable = true;
      };
      html = {
        enable = true;
      };
      cssls = {
        enable = true;
      };
      tsserver = {
        enable = true;
      };
    };
  };
  extraConfigLua = ''
    -- Show diagnostics when InsertLeave and BufWritePost
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "go", "rust", "nix", "haskell" },
      callback = function(args)
        -- Hide diagnostics when they change
        vim.api.nvim_create_autocmd("DiagnosticChanged", {
          buffer = args.buf,
          callback = function()
            vim.diagnostic.hide()
          end,
        })
        
        -- Show diagnostics on InsertLeave and BufWritePost
        vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
          buffer = args.buf,
          callback = function()
            vim.diagnostic.show()
          end,
        })
      end,
    })
  '';
}
