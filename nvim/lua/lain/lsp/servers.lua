---@diagnostic disable: param-type-mismatch
-- nvim/lua/lain/lsp/servers.lua
local M = {}

M.setup = function(on_attach, capabilities)
  local configs = {
    -- Nix
    nil_ls = {
      cmd = { "nil" },
      filetypes = { "nix" },
      root_markers = { "flake.nix", "default.nix", ".git" },
      settings = {
        ["nil"] = {
          formatting = {
            command = { "nixfmt" },
          },
        },
      },
    },

    -- Go
    gopls = {
      settings = {
        gopls = {
          experimentalPostfixCompletions = true,
          analyses = { unusedparams = true, shadow = true },
          staticcheck = true,
          gofumpt = true,
        },
      },
      init_options = { usePlaceholders = true },
    },

    -- Python
    basedpyright = {
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
    },

    -- EmmyLua (Rust version)
    emmylua_ls = {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim", "mnw" } },
          workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        },
      },
    },

    -- C/C++ (Offset encoding fix)
    clangd = {
      capabilities = vim.tbl_deep_extend("force", vim.deepcopy(capabilities), {
        offsetEncoding = { "utf-16" },
      }),
    },

    -- Rust
    rust_analyzer = {
      settings = {
        ["rust-analyzer"] = {
          cargo = { allFeatures = true },
          diagnostics = { enable = true },
          files = { excludeDirs = { ".direnv", "rust/.direnv" } },
        },
      },
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        -- Format on save with a unique augroup to prevent stacking listeners
        local grp = vim.api.nvim_create_augroup("LspFormatRust", { clear = false })
        vim.api.nvim_clear_autocmds({ group = grp, buffer = bufnr })

        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          group = grp,
          callback = function()
            vim.lsp.buf.format({ async = false })
          end,
        })
      end,
    },
  }

  local simple_servers = {
    "taplo",
    "html",
    "cssls",
    "ts_ls",
    "svelte",
    "bashls",
    "hls",
    "cmake",
    "mesonlsp",
  }

  local function register(name, config)
    local defaults = {
      on_attach = on_attach,
      capabilities = capabilities,
    }
    local final_config = vim.tbl_deep_extend("force", defaults, config or {})

    vim.lsp.config(name, final_config)
    vim.lsp.enable(name)
  end

  -- 4. Execution Loop
  for _, name in ipairs(simple_servers) do
    register(name, {})
  end

  for name, conf in pairs(configs) do
    register(name, conf)
  end
end

return M
