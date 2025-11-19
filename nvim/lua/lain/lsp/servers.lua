-- nvim/lua/lain/lsp/servers.lua
local M = {}

M.setup = function(on_attach, capabilities)
  local function common(name, settings)
    vim.lsp.config(
      name,
      vim.tbl_deep_extend("force", {
        on_attach = on_attach,
        capabilities = capabilities,
      }, settings or {})
    )
  end

  -- Server configurations
  common("nixd", {
    settings = {
      nixd = {
        formatting = { command = { "nixfmt" } },
        nixpkgs = { expr = "import <nixpkgs> { }" },
        options = {
          nixos = {
            -- NOTE: This might need to be adapted to your project structure
            expr = '(builtins.getFlake "' .. vim.fn.getcwd() .. '").nixosConfigurations.sforza.options',
          },
          home_manager = {
            expr = '(builtins.getFlake "' .. vim.fn.getcwd() .. '").homeConfigurations."airi@sforza".options',
          },
        },
      },
    },
  })

  common("gopls", {
    settings = {
      gopls = {
        experimentalPostfixCompletions = true,
        analyses = { unusedparams = true, shadow = true },
        staticcheck = true,
        gofumpt = true,
      },
    },
    init_options = { usePlaceholders = true },
  })

  common("basedpyright", {
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

  common("emmylua_ls", {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim", "mnw" } }, -- Added mnw
        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      },
    },
  })

  common("rust_analyzer", {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format()
        end,
      })
    end,
    settings = {
      ["rust-analyzer"] = {
        diagnostics = { enable = true },
        files = { excludeDirs = { ".direnv", "rust/.direnv" } },
      },
    },
  })

  local simple_servers = {
    "taplo",
    "html",
    "cssls",
    "ts_ls",
    "svelte",
    "bashls",
    "hls",
    "clangd",
    "cmake",
    "mesonlsp",
  }

  for _, s in ipairs(simple_servers) do
    common(s)
  end

  -- clangd special case
  local clangd_caps = vim.tbl_deep_extend("force", vim.deepcopy(capabilities), { offsetEncoding = { "utf-16" } })
  vim.lsp.config("clangd", {
    on_attach = on_attach,
    capabilities = clangd_caps,
  })

  -- Finally enable all configured servers
  local all_servers = {
    "nixd",
    "gopls",
    "basedpyright",
    "emmylua_ls",
    "rust_analyzer",
    "taplo",
    "html",
    "cssls",
    "ts_ls",
    "bashls",
    "hls",
    "clangd",
    "cmake",
    "mesonlsp",
    "svelte",
  }
  for _, s in ipairs(all_servers) do
    vim.lsp.enable(s)
  end
end

return M
