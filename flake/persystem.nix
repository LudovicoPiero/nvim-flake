{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      system,
      ...
    }:
    let
      nixvimLib = inputs.nixvim.lib.${system};
      nixvim' = inputs.nixvim.legacyPackages.${system};
      nixvimModule = {
        inherit pkgs;
        module = import ../config; # import the module directly
        # You can use `extraSpecialArgs` to pass additional arguments to your module files
        extraSpecialArgs = {
          inherit (inputs) self;
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
}
