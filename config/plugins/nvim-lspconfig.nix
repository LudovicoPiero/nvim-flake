# Source: https://github.com/Ruixi-rebirth/nvim-flake/blob/68ffe64e325d082504aeee93451fabece55df19f/config/lazy_plugins/nvim-lspconfig.nix#L79
{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  pkg = pkgs.vimPlugins.nvim-lspconfig;
  event = [
    "BufReadPost"
    "BufNewFile"
    "BufWritePre"
  ];
  dependencies = with pkgs.vimPlugins; [ blink-cmp ];
  config = ''
    function()
      local nvim_lsp = vim.lsp.config or require("lspconfig")

      ---------------------
      -- setup languages --
      ---------------------
      local cmp_capabilities = require('blink.cmp').get_lsp_capabilities()
      local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
      local capabilities = vim.tbl_deep_extend("force", lsp_capabilities, cmp_capabilities)
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- Table to track the floating window
      local diag_float = {}
      local on_attach_common = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        local fzf = require("fzf-lua")

        local augroup = vim.api.nvim_create_augroup("LspDiagnosticsFloat", { clear = true })
        vim.api.nvim_create_autocmd("CursorHold", {
          buffer = bufnr,
          group = augroup,
          callback = function()
            local line = vim.api.nvim_win_get_cursor(0)[1]

            -- Check if we have a valid float already for this line
            if diag_float[bufnr] then
              local win = diag_float[bufnr].win
              if win and vim.api.nvim_win_is_valid(win) and diag_float[bufnr].line == line then
                return
              end
              -- Close old float if it exists
              if win and vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
              end
            end

            -- Only open float if there are diagnostics on this line
            local diagnostics = vim.diagnostic.get(0, { lnum = line - 1 })
            if vim.tbl_isempty(diagnostics) then
              diag_float[bufnr] = nil
              return
            end

            -- Diagnostic options
            local opts = {
              focusable = false,
              close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
              border = "rounded",
              source = "always",
              prefix = " ",
              scope = "line",
            }

            local float_win = vim.diagnostic.open_float(nil, opts)

            -- Track the float window and the line it is for
            if float_win then
              diag_float[bufnr] = { win = float_win, line = line }
            else
              diag_float[bufnr] = nil
            end
          end,
        })

        vim.keymap.set("n", "gd", fzf.lsp_definitions, vim.tbl_extend("force", { desc = "Go to definition" }, opts))
        vim.keymap.set("n", "gi", fzf.lsp_implementations, vim.tbl_extend("force", { desc = "Go to implementation" }, opts))
        vim.keymap.set("n", "gr", fzf.lsp_references, vim.tbl_extend("force", { desc = "Find references" }, opts))
        vim.keymap.set("n", "<leader>ca", fzf.lsp_code_actions, vim.tbl_extend("force", { desc = "[C]ode [A]ctions" }, opts))
        vim.keymap.set("n", "<leader>D", fzf.lsp_typedefs, vim.tbl_extend("force", { desc = "Go to type definition" }, opts))
        vim.keymap.set("n", "<leader>st", function() require("todo-comments.fzf").todo() end, vim.tbl_extend("force", { desc = "[S]earch [T]odo" }, opts))
        vim.keymap.set("n", "<leader>sT", function() require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } }) end, vim.tbl_extend("force", { desc = "[S]earch [T]odo and FIXME" }, opts))

        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", { desc = "Hover documentation" }, opts))
        vim.keymap.set("n", "<leader>sS", vim.lsp.buf.signature_help, vim.tbl_extend("force", { desc = "[S]how [S]ignature help" }, opts))
        vim.keymap.set("n", "<leader>n", vim.lsp.buf.rename, vim.tbl_extend("force", { desc = "Rename symbol" }, opts))
        vim.keymap.set("n", "[d", function() vim.diagnostic.jump { count = -1, float = true } end, vim.tbl_extend("force", { desc = "Prev diagnostic" }, opts))
        vim.keymap.set("n", "]d", function() vim.diagnostic.jump { count = 1, float = true } end, vim.tbl_extend("force", { desc = "Next diagnostic" }, opts))
        vim.keymap.set("n", "<leader>L", function() print(vim.inspect(vim.lsp.get_clients({ bufnr = bufnr }))) end, vim.tbl_extend("force", { desc = "List LSP clients" }, opts))
      end

      local has_new_api = vim.lsp and vim.lsp.config and vim.lsp.enable

      if has_new_api then
        vim.lsp.config("nixd", {
          cmd = { "${pkgs.nixd}/bin/nixd" },
          on_attach = on_attach_common,
          capabilities = capabilities,
          settings = {
            nixd = {
              formatting = {
                command = {
                  "${lib.getExe' pkgs.nixfmt-rfc-style "nixfmt"}",
                },
              },
              nixpkgs = {
                expr = "import <nixpkgs> { }",
              },
              options = {
                nixos = {
                  expr = '(builtins.getFlake "${inputs.self}").nixosConfigurations.sforza.options',
                },
                ["home-manager"] = {
                  expr = '(builtins.getFlake "${inputs.self}").homeConfigurations."airi@sforza".options',
                },
              },
            },
          },
        })

        vim.lsp.config("gopls", {
          cmd = { "${pkgs.gopls}/bin/gopls" },
          on_attach = on_attach_common,
          capabilities = capabilities,
          settings = {
            gopls = {
              experimentalPostfixCompletions = true,
              analyses = { unusedparams = true, shadow = true },
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
          init_options = { usePlaceholders = true },
        })

        vim.lsp.config("basedpyright", {
          cmd = { "${pkgs.basedpyright}/bin/basedpyright-langserver", "--stdio" },
          on_attach = on_attach_common,
          capabilities = capabilities,
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

        vim.lsp.config("lua_ls", {
          cmd = { "${pkgs.emmylua-ls}/bin/emmylua_ls" },
          on_attach = on_attach_common,
          capabilities = capabilities,
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            },
          },
        })

        vim.lsp.config("rust_analyzer", {
          cmd = { "${pkgs.rust-analyzer}/bin/rust-analyzer" },
          on_attach = function(client, bufnr)
            on_attach_common(client, bufnr)
            vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])
          end,
          capabilities = capabilities,
          settings = {
            ["rust-analyzer"] = {
              diagnostics = { enable = true, styleLints = { enable = true } },
              files = { excludeDirs = { ".direnv", "rust/.direnv" } },
              inlayHints = {
                bindingModeHints = { enable = true },
                closureReturnTypeHints = { enable = "always" },
                discriminantHints = { enable = "always" },
                expressionAdjustmentHints = { enable = "always" },
                lifetimeElisionHints = { enable = "always" },
                rangeExclusiveHints = { enable = true },
              },
              procMacro = { enable = true },
            },
          },
        })

        vim.lsp.config("taplo", {
          cmd = { "${pkgs.taplo}/bin/taplo", "lsp", "stdio" },
          on_attach = on_attach_common,
          capabilities = capabilities,
        })

        vim.lsp.config("html", {
          cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server", "--stdio" },
          on_attach = on_attach_common,
          capabilities = capabilities,
        })

        vim.lsp.config("cssls", {
          cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server", "--stdio" },
          on_attach = on_attach_common,
          capabilities = capabilities,
        })

        vim.lsp.config("ts_ls", {
          cmd = { "${pkgs.typescript-language-server}/bin/typescript-language-server", "--stdio" },
          on_attach = on_attach_common,
          capabilities = capabilities,
        })

        vim.lsp.config("vue_ls", {
          cmd = { "${pkgs.vue-language-server}/bin/vue-language-server", "--stdio" },
          on_attach = on_attach_common,
          capabilities = capabilities,
        })

        vim.lsp.config("bashls", {
          cmd = { "${pkgs.bash-language-server}/bin/bash-language-server", "start" },
          on_attach = on_attach_common,
          capabilities = capabilities,
        })

        vim.lsp.config("hls", {
          cmd = { "${pkgs.haskell-language-server}/bin/haskell-language-server-wrapper", "--lsp" },
          on_attach = function(client, bufnr)
            on_attach_common(client, bufnr)
            vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])
          end,
          capabilities = capabilities,
        })

        vim.lsp.config("clangd", {
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
          capabilities = vim.tbl_deep_extend("force", capabilities, { offsetEncoding = { "utf-16" } }),
        })

        vim.lsp.config("cmake", {
          cmd = { "${pkgs.cmake-language-server}/bin/cmake-language-server" },
          on_attach = on_attach_common,
          capabilities = capabilities,
        })

        vim.lsp.config("mesonlsp", {
          cmd = { "${pkgs.mesonlsp}/bin/mesonlsp", "--lsp" },
          on_attach = function(client, bufnr)
            on_attach_common(client, bufnr)
            vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])
          end,
          capabilities = capabilities,
        })

        -- ---------------------
        -- Enable all configured servers
        -- ---------------------
        local servers = {
          "nixd", "gopls", "basedpyright", "lua_ls", "rust_analyzer",
          "taplo", "html", "cssls", "ts_ls", "vue_ls", "bashls",
          "hls", "clangd", "cmake", "mesonlsp",
        }

        for _, s in ipairs(servers) do
          vim.lsp.enable(s)
        end

      -- =========================================================
      -- Fallback for Neovim ≤ 0.10
      -- =========================================================
      else
        local nvim_lsp = require("lspconfig")
        -- nix
        nvim_lsp.nixd.setup({
          cmd = { "${pkgs.nixd}/bin/nixd" },
          on_attach = on_attach_common,
          capabilities = capabilities,
          settings = {
              nixd = {
                  -- diagnostic = { suppress = { "sema-escaping-with", "var-bind-to=this" } },
                  formatting = {
                      command = {
                          "${lib.getExe' pkgs.nixfmt-rfc-style "nixfmt"}",
                      },
                  },
                  nixpkgs = {
                      expr = 'import <nixpkgs> { }',
                  },
                  options = {
                      nixos = {
                          expr = '(builtins.getFlake \"${inputs.self}\").nixosConfigurations.sforza.options',
                      },
                      ["home-manager"] = {
                          expr = '(builtins.getFlake \"${inputs.self}\").homeConfigurations."airi@sforza".options',
                      },
                  },
              },
          },
        })

        -- golang
        nvim_lsp["gopls"].setup({
          cmd = { "${pkgs.gopls}/bin/gopls" },
          on_attach = on_attach_common,
          capabilities = capabilities,
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
          capabilities = capabilities,
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
          cmd = { "${pkgs.emmylua-ls}/bin/emmylua_ls" },
          on_attach = on_attach_common,
          capabilities = capabilities,
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
                -- checkThirdParty = false,
              },
              -- Do not send telemetry data containing a randomized but unique identifier
              -- telemetry = {
              --   enable = false,
              -- },
            },
          },
        })

        nvim_lsp.rust_analyzer.setup({
          cmd = { "${pkgs.rust-analyzer}/bin/rust-analyzer" },
          on_attach = function(client, bufnr)
            on_attach_common(client, bufnr)
            vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])
          end,
          capabilities = capabilities,
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

        nvim_lsp.taplo.setup({
          cmd = { "${pkgs.taplo}/bin/taplo", "lsp", "stdio" },
          on_attach = on_attach_common,
          capabilities = capabilities,
        })

        nvim_lsp.html.setup({
          cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server", "--stdio" },
          on_attach = on_attach_common,
          capabilities = capabilities,
        })

        nvim_lsp.cssls.setup({
          cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server", "--stdio" },
          on_attach = on_attach_common,
          capabilities = capabilities,
        })

        nvim_lsp.ts_ls.setup({
          cmd = { "${pkgs.typescript-language-server}/bin/typescript-language-server", "--stdio" },
          on_attach = on_attach_common,
          capabilities = capabilities,
        })

        nvim_lsp.volar.setup({
          cmd = { "${pkgs.vue-language-server}/bin/vue-language-server", "--stdio" },
          on_attach = on_attach_common,
          capabilities = capabilities,
        })

        nvim_lsp.bashls.setup({
          cmd = { "${pkgs.bash-language-server}/bin/bash-language-server", "start" },
          on_attach = on_attach_common,
          capabilities = capabilities,
        })

        nvim_lsp.hls.setup({
          cmd = { "${pkgs.haskell-language-server}/bin/haskell-language-server-wrapper", "--lsp" },
          on_attach = function(client, bufnr)
            on_attach_common(client, bufnr)
            vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])
          end,
          capabilities = capabilities,
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
          capabilities = vim.tbl_deep_extend("force", capabilities, {
            offsetEncoding = { "utf-16" },
          }),
        })

        nvim_lsp.cmake.setup({
          cmd = { "${pkgs.cmake-language-server}/bin/cmake-language-server" },
          on_attach = on_attach_common,
          capabilities = capabilities,
        })

        nvim_lsp.mesonlsp.setup({
          cmd = { "${pkgs.mesonlsp}/bin/mesonlsp", "--lsp" },
          on_attach = function(client, bufnr)
            on_attach_common(client, bufnr)
            vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])
          end,
          capabilities = capabilities,
        })
      end
    end
  '';
}
