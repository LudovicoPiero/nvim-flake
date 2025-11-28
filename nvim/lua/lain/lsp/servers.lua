---@diagnostic disable: param-type-mismatch, undefined-global
local M = {}

M.setup = function()
  -- LSP capabilities.
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- Actions on attaching to a buffer.
  local diagnostic_augroup = vim.api.nvim_create_augroup("LspDiagnosticsFloat", { clear = true })

  local on_attach = function(client, bufnr)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    -- Show diagnostics on hover.
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = bufnr,
      group = diagnostic_augroup,
      callback = function()
        vim.diagnostic.open_float(nil, {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          border = "rounded",
          source = "always",
          prefix = " ",
          scope = "cursor",
        })
      end,
    })

    -- Navigation
    map("gd", function()
      Snacks.picker.lsp_definitions()
    end, "Go to Definition")
    map("gD", function()
      Snacks.picker.lsp_declarations()
    end, "Go to Declaration")
    map("gi", function()
      Snacks.picker.lsp_implementations()
    end, "Go to Implementation")
    map("grr", function()
      Snacks.picker.lsp_references()
    end, "Find References")
    map("<leader>D", function()
      Snacks.picker.lsp_type_definitions()
    end, "Type Definition")

    -- Symbol-related actions.
    map("gai", function()
      Snacks.picker.lsp_incoming_calls()
    end, "Calls Incoming")
    map("gao", function()
      Snacks.picker.lsp_outgoing_calls()
    end, "Calls Outgoing")
    map("<leader>ss", function()
      Snacks.picker.lsp_symbols()
    end, "Document Symbols")
    map("<leader>sS", function()
      Snacks.picker.lsp_workspace_symbols()
    end, "Workspace Symbols")

    -- Code actions.
    map("<leader>ca", vim.lsp.buf.code_action, "Code Actions")
    map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("gK", vim.lsp.buf.signature_help, "Signature Help")

    -- Diagnostic navigation.
    map("[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, "Prev Diagnostic")
    map("]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, "Next Diagnostic")

    -- Toggle inlay hints.
    if client.server_capabilities.inlayHintProvider then
      map("<leader>th", function()
        local current = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
        vim.lsp.inlay_hint.enable(not current, { bufnr = bufnr })
      end, "Toggle Inlay Hints")
    end
  end

  -- Language server configurations.
  local configs = {
    -- Nix (nil_ls)
    nil_ls = {
      cmd = { "nil" },
      filetypes = { "nix" },
      root_markers = { "flake.nix", "default.nix", ".git" },
      settings = {
        ["nil"] = {
          nix = {
            flake = {
              autoArchive = true,
            },
          },
        },
      },
    },

    -- Go (gopls)
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

    -- Python (basedpyright)
    basedpyright = {
      settings = {
        basedpyright = {
          disableOrganizeImports = true, -- Let Ruff handle this
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "workspace",
            useLibraryCodeForTypes = true,
            typeCheckingMode = "strict",

            diagnosticSeverityOverrides = {
              -- Downgrade some errors to warnings.
              reportUnknownParameterType = "warning",
              reportMissingParameterType = "warning",
              reportUnknownArgumentType = "warning",
              reportUnknownLambdaType = "warning",
              reportUnknownMemberType = "warning",
              reportUntypedFunctionDecorator = "warning",
              reportDeprecated = "warning",

              -- Restore unused warnings.
              reportUnusedFunction = "warning",
              reportUnusedVariable = "warning",

              -- Enable extra checks.
              reportUnusedCallResult = "warning",
              reportUninitializedInstanceVariable = "warning",

              -- Silence noise for new projects.
              reportMissingImports = false,
              reportMissingTypeStubs = false, -- Very important for libraries
              reportUnknownVariableType = false,

              -- Let ruff handle imports.
              reportUnusedImport = "warning",
            },
          },
        },
      },
    },

    -- Lua (emmylua_ls)
    emmylua_ls = {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim", "mnw" } },
          workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        },
      },
    },

    -- C/C++ (clangd)
    clangd = {
      capabilities = vim.tbl_deep_extend("force", vim.deepcopy(capabilities), {
        offsetEncoding = { "utf-16" },
      }),
    },

    -- Rust (rust_analyzer)
    rust_analyzer = {
      settings = {
        ["rust-analyzer"] = {
          cargo = { allFeatures = true },
          diagnostics = { enable = true },
          files = { excludeDirs = { ".direnv", "rust/.direnv" } },
        },
      },
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

  -- Register servers.
  local function register(name, config)
    local final_config = vim.tbl_deep_extend("force", {
      on_attach = on_attach,
      capabilities = capabilities,
      root_markers = { ".git" },
    }, config or {})

    vim.lsp.config(name, final_config)
    vim.lsp.enable(name)
  end

  for _, name in ipairs(simple_servers) do
    register(name, {})
  end
  for name, conf in pairs(configs) do
    register(name, conf)
  end
end

return M
