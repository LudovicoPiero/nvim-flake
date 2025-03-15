{
  pkgs,
  self,
  ...
}:
{
  plugins.nix.enable = true;
  plugins.lsp.servers = {
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
      settings =
        let
          getFlake = ''(builtins.getFlake "${self}")'';
        in
        {
          diagnostic.suppress = [
            "sema-escaping-with"
            "var-bind-to=this"
          ];
          formatting.command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
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

    rust_analyzer = {
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
}
