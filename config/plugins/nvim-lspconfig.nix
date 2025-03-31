# Source: https://github.com/Ruixi-rebirth/nvim-flake/blob/68ffe64e325d082504aeee93451fabece55df19f/config/lazy_plugins/nvim-lspconfig.nix#L79
{
  pkgs,
  lib,
  self,
  ...
}:
let
  getFlake = ''(builtins.getFlake "${self}")'';
in
{
  pkg = pkgs.vimPlugins.nvim-lspconfig;
  event = [
    "BufReadPost"
    "BufNewFile"
    "BufWritePre"
  ];
  dependencies = with pkgs.vimPlugins; [
    # nvim-cmp
    blink-cmp
  ];
  config = ''
    function()
      -- Add additional capabilities supported by nvim-cmp
      -- local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Blink
      local cmp_capabilities = require('blink.cmp').get_lsp_capabilities()

      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local on_attach_common = function(client, bufnr)
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
            vim.diagnostic.show()
            vim.diagnostic.open_float(nil, opts)
          end,
        })

        -- keymap
        local opts = { noremap = true, silent = true, buffer = bufnr }

        vim.keymap.set("n", "gd", function() require('telescope.builtin').lsp_definitions() end, vim.tbl_extend("force", { desc = "Go to definition" }, opts or {}))
        vim.keymap.set("n", "gi", function() require('telescope.builtin').lsp_implementations() end, vim.tbl_extend("force", { desc = "Go to implementation" }, opts or {}))
        vim.keymap.set("n", "gr", function() require('telescope.builtin').lsp_references() end, vim.tbl_extend("force", { desc = "Find references" }, opts or {}))
        vim.keymap.set("n", "<leader>D", function() require('telescope.builtin').lsp_type_definitions() end, vim.tbl_extend("force", { desc = "Go to type definition" }, opts or {}))

        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, vim.tbl_extend("force", { desc = "Hover documentation" }, opts or {}))
        vim.keymap.set("n", "<leader>s", function() vim.lsp.buf.signature_help() end, vim.tbl_extend("force", { desc = "Show signature help" }, opts or {}))
        vim.keymap.set("n", "<leader>ca", function() require('telescope.builtin').lsp_code_actions() end, vim.tbl_extend("force", { desc = "[C]ode [A]ctions" }, opts or {}))
        vim.keymap.set("n", "<leader>n", function() vim.lsp.buf.rename() end, vim.tbl_extend("force", { desc = "Rename symbol" }, opts or {}))

        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, vim.tbl_extend("force", { desc = "Go to previous diagnostic" }, opts or {}))
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, vim.tbl_extend("force", { desc = "Go to next diagnostic" }, opts or {}))

        vim.keymap.set("n", "<leader>L", function() print(vim.inspect(vim.lsp.get_clients({ bufnr = bufnr }))) end, vim.tbl_extend("force", { desc = "List LSP clients" }, opts or {}))

        -- vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]] -- use none-ls
      end

      local nvim_lsp = require("lspconfig")
      ---------------------
      -- setup languages --
      ---------------------
      -- nix
      nvim_lsp.nixd.setup({
        cmd = { "${pkgs.nixd}/bin/nixd" },
        on_attach = on_attach_common,
        capabilities = cmp_capabilities,
        settings = {
            nixd = {
                -- diagnostic = { suppress = { "sema-escaping-with", "var-bind-to=this" } },
                formatting = {
                    command = {
                        "${lib.getExe' pkgs.nixfmt-rfc-style "nixfmt"}",
                    },
                },
                nixpkgs = {
                    expr = 'import (builtins.getFlake "${getFlake}").inputs.nixpkgs { }   ',
                },
                options = {
                    ["flake-parts"] = {
                        expr = 'let flake = (builtins.getFlake "${getFlake}"); in flake.debug.options // flake.currentSystem.options',
                    },
                    ["home-manager"] = {
                        expr = '(builtins.getFlake "${getFlake}").homeConfigurations."airi@sforza".options',
                    },
                    nixos = {
                        expr = '(builtins.getFlake "${getFlake}").nixosConfigurations.sforza.options',
                    },
                    nixvim = {
                        expr = '(builtins.getFlake "${getFlake}").packages.x86_64-linux.nvim.options',
                    },
                },
            },
        },
      })

      -- golang
      nvim_lsp["gopls"].setup({
        cmd = { "${pkgs.gopls}/bin/gopls" },
        on_attach = on_attach_common,
        capabilities = cmp_capabilities,
        settings = {
          gopls = {
            experimentalPostfixCompletions = true,
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
            gofumpt = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
        init_options = {
          usePlaceholders = true,
        },
      })

      --python
      nvim_lsp.basedpyright.setup({
        cmd = { "${pkgs.basedpyright}/bin/basedpyright-langserver", "--stdio" },
        on_attach = on_attach_common,
        capabilities = cmp_capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "off",
            },
          },
        },
      })

      --lua
      nvim_lsp.lua_ls.setup({
        cmd = { "${pkgs.lua-language-server}/bin/lua-language-server" },
        on_attach = on_attach_common,
        capabilities = cmp_capabilities,
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        },
      })

      nvim_lsp.rust_analyzer.setup({
        cmd = { "${pkgs.rust-analyzer}/bin/rust-analyzer" },
        on_attach = function(client, bufnr)
          on_attach_common(client, bufnr)
          vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])
        end,
        capabilities = cmp_capabilities,
        settings = {
            ["rust-analyzer"] = {
                diagnostics = { enable = true, styleLints = { enable = true } },
                files = { excludeDirs = { ".direnv", "rust/.direnv" } },
                inlayHints = {
                    bindingModeHints = { enable = true },
                    closureReturnTypeHints = { enable = "always" },
                    closureStyle = "rust_analyzer",
                    discriminantHints = { enable = "always" },
                    expressionAdjustmentHints = { enable = "always" },
                    implicitDrops = { enable = true },
                    lifetimeElisionHints = { enable = "always" },
                    rangeExclusiveHints = { enable = true },
                },
                procMacro = { enable = true },
            },
        },
      })

      nvim_lsp.html.setup({
        cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server", "--stdio" },
        on_attach = on_attach_common,
        capabilities = cmp_capabilities,
      })

      nvim_lsp.cssls.setup({
        cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server", "--stdio" },
        on_attach = on_attach_common,
        capabilities = cmp_capabilities,
      })

      nvim_lsp.ts_ls.setup({
        cmd = { "${pkgs.typescript-language-server}/bin/typescript-language-server", "--stdio" },
        on_attach = on_attach_common,
        capabilities = cmp_capabilities,
      })

      nvim_lsp.volar.setup({
        cmd = { "${pkgs.vue-language-server}/bin/vue-language-server", "--stdio" },
        on_attach = on_attach_common,
        capabilities = cmp_capabilities,
      })

      nvim_lsp.bashls.setup({
        cmd = { "${pkgs.bash-language-server}/bin/bash-language-server", "start" },
        on_attach = on_attach_common,
        capabilities = cmp_capabilities,
      })

      nvim_lsp.hls.setup({
        cmd = { "${pkgs.haskell-language-server}/bin/haskell-language-server-wrapper", "--lsp" },
        on_attach = function(client, bufnr)
          on_attach_common(client, bufnr)
          vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])
        end,
        capabilities = cmp_capabilities,
      })

      nvim_lsp.clangd.setup({
        cmd = {
          "${pkgs.clang-tools}/bin/clangd",
          "--enable-config",
          "--pch-storage=memory",
          "--compile-commands-dir=''${workspaceFolder}/build",
          "--background-index",
          "--clang-tidy",
          "--log=verbose",
          "--all-scopes-completion",
          "--header-insertion=iwyu",
          "--fallback-style=LLVM",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--pretty",
        },
        on_attach = on_attach_common,
        capabilities = vim.tbl_deep_extend("force", cmp_capabilities, {
          offsetEncoding = { "utf-16" },
        }),
      })

      nvim_lsp.cmake.setup({
        cmd = { "${pkgs.cmake-language-server}/bin/cmake-language-server" },
        on_attach = on_attach_common,
        capabilities = cmp_capabilities,
      })

      nvim_lsp.mesonlsp.setup({
        cmd = { "${pkgs.mesonlsp}/bin/mesonlsp", "--lsp" },
        on_attach = function(client, bufnr)
          on_attach_common(client, bufnr)
          vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])
        end,
        capabilities = cmp_capabilities,
      })

      -- show diagnostics when InsertLeave
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "go", "rust", "nix", "haskell", "cpp", "c" },
        callback = function(args)
          vim.api.nvim_create_autocmd("DiagnosticChanged", {
            buffer = args.buf,
            callback = function()
              vim.diagnostic.hide()
            end,
          })
          vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
            buffer = args.buf,
            callback = function()
              vim.diagnostic.show()
            end,
          })
        end,
      })

      _G.toggle_inlay_hints = function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "rust", "go", "nix" },
        callback = function()
          vim.api.nvim_buf_create_user_command(0, "InlayHintsToggle", _G.toggle_inlay_hints, {})
        end,
      })
    end
  '';
}
