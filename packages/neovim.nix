{
  pkgs,
  lib,
  inputs,
  inputs',
  ...
}:
let
  # --- Tool Groups ---
  nixTools = with pkgs; [
    deadnix
    statix
    nixfmt
    nil
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
        inherit name;
        src = v { inherit pkgs; };
        doCheck = false;
      }
    ) (import ../npins/npins.nix { inherit input; });
in
inputs.mnw.lib.wrap pkgs {
  inherit (inputs'.nvim-overlay.packages) neovim;

  # Load init.lua at startup
  luaFiles = [ ../init.lua ];

  plugins = {
    start = [
      pkgs.vimPlugins.plenary-nvim
      pkgs.vimPlugins.nui-nvim
    ];

    # Lazy loaded plugins
    opt = with pkgs.vimPlugins; [ nvim-treesitter.withAllGrammars ];

    # Map manual flake packages
    optAttrs = npinsToPlugins ../npins/sources.json;

    dev.lain = {
      pure = lib.fileset.toSource {
        root = ../.;
        fileset = lib.fileset.unions [
          ../init.lua
          ../nvim
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
}
