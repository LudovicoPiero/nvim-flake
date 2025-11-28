---@diagnostic disable: param-type-mismatch, undefined-global
local M = {}

M.setup = function()
  -- 1. Capabilities
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- 2. On Attach
  local diagnostic_augroup = vim.api.nvim_create_augroup("LspDiagnosticsFloat", { clear = true })

  local on_attach = function(client, bufnr)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    -- Auto-hover diagnostics
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

    -- Navigation (Snacks)
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

    -- Symbols
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

    -- Actions
    map("<leader>ca", vim.lsp.buf.code_action, "Code Actions")
    map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("gK", vim.lsp.buf.signature_help, "Signature Help")

    -- Diagnostics
    map("[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, "Prev Diagnostic")
    map("]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, "Next Diagnostic")

    -- Toggle Inlay Hints
    if client.server_capabilities.inlayHintProvider then
      map("<leader>th", function()
        local current = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
        vim.lsp.inlay_hint.enable(not current, { bufnr = bufnr })
      end, "Toggle Inlay Hints")
    end
  end

  -- 3. Server Configs
  local configs = {
    -- Nix
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
        basedpyright = {
          disableOrganizeImports = true, -- Let Ruff handle this
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "workspace",
            useLibraryCodeForTypes = true,
            typeCheckingMode = "strict",

            diagnosticSeverityOverrides = {
              -- 1. Downgrade Errors to Warnings (Keep the noise manageable)
              reportUnknownParameterType = "warning",
              reportMissingParameterType = "warning",
              reportUnknownArgumentType = "warning",
              reportUnknownLambdaType = "warning",
              reportUnknownMemberType = "warning",
              reportUntypedFunctionDecorator = "warning",
              reportDeprecated = "warning",

              -- 2. Restore "Unused" Warnings
              reportUnusedFunction = "warning",
              reportUnusedVariable = "warning",

              -- 3. Enable Extra Checks
              reportUnusedCallResult = "warning",
              reportUninitializedInstanceVariable = "warning",

              -- 4. Silence things that annoy new projects
              reportMissingImports = false,
              reportMissingTypeStubs = false, -- Very important for libraries
              reportUnknownVariableType = false,

              -- 5. Let Ruff handle imports entirely
              reportUnusedImport = "warning",
            },
          },
        },
      },
    },

    -- Lua
    emmylua_ls = {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim", "mnw" } },
          workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        },
      },
    },

    -- C/C++
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

  -- 4. Setup Loop
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
