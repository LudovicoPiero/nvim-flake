{
  inputs,
  pkgs,
  ...
}:
{
  # Only used for nixd lsp
  flake = {
    nixosConfigurations = {
      sforza = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            networking.hostName = "sforza";
            system.stateVersion = "24.11";
            boot.loader.grub.device = "/dev/disk/by-id/wwn-0x500001234567890a"; # FAKE ID, to make `nix flake check` happy.
            fileSystems."/" = {
              device = "/dev/disk/by-label/root";
              fsType = "ext4";
            };
          }
        ];
      };
    };

    homeConfigurations = {
      "airi@sforza" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          {
            home.stateVersion = "24.11";
            home.username = "airi";
            home.homeDirectory = "/home/airi";
            home.packages = [ pkgs.hello ];
          }
        ];
      };
    };
  };
}
