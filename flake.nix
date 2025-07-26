{
  description = "Home Manager configuration of lemonday";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    # nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl.url = "github:nix-community/nixGL";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixgl, agenix, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."lemonday" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          agenix.homeManagerModules.default
          ./home.nix
          ./modules/default.nix
          inputs.sops-nix.homeManagerModules.sops
          {
            nixGL = {
              packages = nixgl.packages;
              defaultWrapper = "mesa";
              installScripts = [ "mesa" ];
              vulkan.enable = true;
            };
          }
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };
}
