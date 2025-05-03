# Source: https://github.com/Ruixi-rebirth/nvim-flake/blob/68ffe64e325d082504aeee93451fabece55df19f/config/lazy_plugins/nvim-lspconfig.nix#L79
{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  getFlake = ''(builtins.getFlake "${inputs.self}")'';
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
      local cmp_capabilities = require('blink.cmp').get_lsp_capabilities()

      local on_attach_common = function(client, bufnr)
        -- keymap
        local opts = { noremap = true, silent = true, buffer = bufnr }

        vim.keymap.set("n", "gd", function() require('telescope.builtin').lsp_definitions() end, vim.tbl_extend("force", { desc = "Go to definition" }, opts or {}))
        vim.keymap.set("n", "gi", function() require('telescope.builtin').lsp_implementations() end, vim.tbl_extend("force", { desc = "Go to implementation" }, opts or {}))
        vim.keymap.set("n", "gr", function() require('telescope.builtin').lsp_references() end, vim.tbl_extend("force", { desc = "Find references" }, opts or {}))
        vim.keymap.set("n", "<leader>D", function() require('telescope.builtin').lsp_type_definitions() end, vim.tbl_extend("force", { desc = "Go to type definition" }, opts or {}))

        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, vim.tbl_extend("force", { desc = "Hover documentation" }, opts or {}))
        vim.keymap.set("n", "<leader>sS", function() vim.lsp.buf.signature_help() end, vim.tbl_extend("force", { desc = "[S]how [S]ignature help" }, opts or {}))
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
              formatting = {
                  command = {
                      "${lib.getExe' pkgs.nixfmt-rfc-style "nixfmt"}",
                  },
              },
              nixpkgs = {
                expr = "import <nixpkgs> { }",
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
        cmd = { "${
          inputs.emmylua.packages.${pkgs.stdenv.hostPlatform.system}.emmylua_ls
        }/bin/emmylua_ls" },
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

      nvim_lsp.taplo.setup({
        cmd = { "${pkgs.taplo}/bin/taplo", "lsp", "stdio" },
        on_attach = on_attach_common,
        capabilities = cmp_capabilities,
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
    end
  '';
}
