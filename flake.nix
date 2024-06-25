{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    {
      self,
      nixvim,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      systems = [ "x86_64-linux" ];

      perSystem =
        { pkgs, system, ... }:
        let
          nixvimLib = nixvim.lib.${system};
          nixvim' = nixvim.legacyPackages.${system};
          nixvimModule = {
            inherit pkgs;
            module = import ./config; # import the module directly
            # You can use `extraSpecialArgs` to pass additional arguments to your module files
            extraSpecialArgs = {
              # inherit (inputs) foo;
              inherit self;
            };
          };
          nvim = nixvim'.makeNixvimWithModule nixvimModule;
        in
        {
          formatter = pkgs.nixfmt-rfc-style;
          checks = {
            # Run `nix flake check .` to verify that your config is not broken
            default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
          };

          packages = {
            inherit nvim;
            default = nvim;
          };
        };

      # Only used for nixd lsp
      flake = {
        nixosConfigurations = {
          sforza = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              (
                { pkgs, ... }:
                {
                  networking.hostName = "sforza";
                  environment.systemPackages = with pkgs; [ nixd ];
                  system.stateVersion = "24.11";
                  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x500001234567890a"; # FAKE ID, to make `nix flake check` happy.
                  fileSystems."/" = {
                    device = "/dev/disk/by-label/root";
                    fsType = "ext4";
                  };
                }
              )
            ];
          };
        };

        homeConfigurations = {
          "airi@sforza" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              {
                home.stateVersion = "24.05";
                home.username = "airi";
                home.homeDirectory = "/home/sforza";
              }
              (
                { pkgs, ... }:
                {
                  wayland.windowManager.hyprland.enable = true;
                }
              )
            ];
          };
        };
      };
    };
}
