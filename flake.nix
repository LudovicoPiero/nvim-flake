{
  description = "Ludovico's nixvim configuration";

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ./packages ];
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
              npinsToPlugins =
                input: builtins.mapAttrs (_: v: v { inherit pkgs; }) (import ./npins/npins.nix { inherit input; });
            in
            {
              default = inputs.mnw.lib.wrap pkgs {
                inherit (inputs'.nvim-overlay.packages) neovim;

                initLua = ''
                  require("lain")
                  require("lz.n").load("lazy")
                '';

                plugins = {
                  start = [
                    pkgs.vimPlugins.lz-n
                    pkgs.vimPlugins.plenary-nvim
                  ];

                  # Anything that you're loading lazily should be put here
                  opt = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];
                  optAttrs = {
                    "blink.cmp" = self'.packages.blink-cmp;
                    "blink.pairs" = self'.packages.blink-pairs;
                  }
                  // npinsToPlugins ./npins/sources.json;

                  dev.lain = {
                    # is this necessary?
                    pure = lib.fileset.toSource {
                      root = ./.;
                      fileset = lib.fileset.unions [ ./lua ];
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

                extraBinPath = with pkgs; [
                  # --- Nix ---
                  statix
                  nixfmt
                  nixd

                  # --- Go ---
                  go
                  gopls
                  gotools
                  golangci-lint
                  gofumpt

                  # --- Python ---
                  basedpyright
                  ruff
                  black

                  # --- Rust ---
                  rust-analyzer
                  rustfmt
                  cargo
                  clippy

                  # --- Lua ---
                  emmylua-ls # LSP for Lua (also known as sumneko_lua)
                  emmylua-check
                  stylua # Lua code formatter
                  luajitPackages.luacheck # Lua linter

                  # --- C/C++ ---
                  clang-tools # includes clangd, clang-format, etc.
                  cmake-language-server
                  mesonlsp
                  gcc
                  gn
                  cmake-format

                  # --- Common tools ---
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
                  chafa
                  # inputs'.self.packages.tree-sitter-cli #TODO
                ];
              };

              nvim = self'.packages.default;
              dev = self'.packages.default.devMode;
            };
        };
    };

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mnw = {
      type = "github";
      owner = "gerg-l";
      repo = "mnw";
    };

    nvim-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    rust-overlay = {
      type = "github";
      owner = "oxalica";
      repo = "rust-overlay";
      rev = "59c45eb69d9222a4362673141e00ff77842cd219"; # 2025-10-31
    };
  };
}
