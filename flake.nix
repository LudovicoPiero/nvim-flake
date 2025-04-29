{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    flake-parts.url = "github:hercules-ci/flake-parts";

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-overlay.inputs.nixpkgs.follows = "nixpkgs";
    neovim-overlay.inputs.flake-parts.follows = "flake-parts";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.flake-parts.follows = "flake-parts";

    emmylua.url = "github:CppCXY/emmylua-analyzer-rust";
    emmylua.inputs.nixpkgs.follows = "nixpkgs";

    # Plugins
    #TODO: remove after merged
    # blink-pairs.url = "github:Saghen/blink.pairs";
    blink-pairs.url = "github:xarvex/blink.pairs/nix-nightly-toolchain";
    blink-pairs.inputs.nixpkgs.follows = "nixpkgs";
    blink-pairs.inputs.fenix.follows = "fenix";
    blink-pairs.inputs.flake-parts.follows = "flake-parts";
  };

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [ ./flake ];
    };
}
