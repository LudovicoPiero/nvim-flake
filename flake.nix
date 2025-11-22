{
  description = "Ludovico's nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mnw.url = "github:gerg-l/mnw";

    nvim-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay/59c45eb69d9222a4362673141e00ff77842cd219";
    };
  };

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./flake
        ./packages
      ];

      systems = [ "x86_64-linux" ];

      perSystem =
        {
          pkgs,
          lib,
          inputs',
          self',
          ...
        }:
        {
          packages =
            let
              # --- Tool Groups ---
              nixTools = with pkgs; [
                statix
                nixfmt
                nixd
              ];

              goTools = with pkgs; [
                go
                gopls
                gotools
                golangci-lint
                gofumpt
              ];

              pythonTools = with pkgs; [
                basedpyright
                ruff
                black
              ];

              rustTools = with pkgs; [
                rust-analyzer
                rustfmt
                cargo
                clippy
              ];

              luaTools = with pkgs; [
                emmylua-ls
                emmylua-check
                stylua
                luajitPackages.luacheck
              ];

              cppTools = with pkgs; [
                clang-tools
                cmake-language-server
                mesonlsp
                gcc
                gn
                cmake-format
              ];

              commonTools = with pkgs; [
                copilot-language-server
                bash-language-server
                shellharden
                typescript-language-server
                haskell-language-server
                shfmt
                shellcheck
                nodePackages.prettier
                taplo
                marksman
                nodePackages.yaml-language-server
                vscode-langservers-extracted
                svelte-language-server
                chafa
                fzf
                ripgrep
                bat
                fd
              ];

              # Helper for npins plugins
              npinsToPlugins =
                input:
                builtins.mapAttrs (
                  name: v:
                  # Wrap the raw source in buildVimPlugin to generate doc/tags
                  pkgs.vimUtils.buildVimPlugin {
                    name = name;
                    src = v { inherit pkgs; };
                    doCheck = false;
                  }
                ) (import ./npins/npins.nix { inherit input; });
            in
            {
              default = inputs.mnw.lib.wrap pkgs {
                inherit (inputs'.nvim-overlay.packages) neovim;

                # Load init.lua at startup
                luaFiles = [ ./init.lua ];

                plugins = {
                  start = [
                    pkgs.vimPlugins.plenary-nvim
                    pkgs.vimPlugins.nui-nvim
                  ];

                  # Lazy loaded plugins
                  opt = with pkgs.vimPlugins; [ nvim-treesitter.withAllGrammars ];

                  # Map manual flake packages
                  optAttrs = {
                    "blink.cmp" = self'.packages.blink-cmp;
                    "blink.pairs" = self'.packages.blink-pairs;
                  }
                  // npinsToPlugins ./npins/sources.json;

                  dev.lain = {
                    pure = lib.fileset.toSource {
                      root = ./.;
                      fileset = lib.fileset.unions [
                        ./init.lua
                        ./nvim
                      ];
                    };
                  };
                };

                extraLuaPackages = p: [ p.jsregexp ];

                providers = {
                  ruby.enable = true;
                  python3.enable = true;
                  nodeJs.enable = true;
                  perl.enable = true;
                };

                # Add all tools to the Neovim PATH
                extraBinPath =
                  nixTools
                  ++ goTools
                  ++ pythonTools
                  ++ rustTools
                  ++ luaTools
                  ++ cppTools
                  ++ commonTools;
              };

              # Aliases for convenience
              nvim = self'.packages.default;
              neovim = self'.packages.default;
            };
        };
    };
}
