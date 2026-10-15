{
  description = "Home Manager personal configuration of southclementide";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl.url = "github:nix-community/nixGL";
    ngosen.url = "github:ngosen/ngosen";
  };

  outputs =
    { self
    , nixpkgs
    , nixgl
    , home-manager
    , ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      inherit (pkgs) lib;
      helpers = import ./helpers.nix { inherit pkgs lib; };

      # Base modules shared across all homeConfigurations
      commonModules = [
        inputs.sops-nix.homeManagerModules.sops
        ./home.nix
        ./modules/common
        {
          home = {
            username = "southclementide";
            homeDirectory = "/home/southclementide";
          };
        }
      ];

      # Helper function to construct a home-manager configuration
      mkHomeConfiguration = extraModules: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = commonModules ++ extraModules;
        extraSpecialArgs = {
          inherit inputs helpers;
        };
      };
    in
    {
      homeConfigurations = {
        "personal" = mkHomeConfiguration [
          ./modules/personal
          {
            home.packages = [
              inputs.ngosen.packages.${system}.default
            ];
            targets.genericLinux.nixGL = {
              packages = nixgl.packages;
              defaultWrapper = "mesa";
              installScripts = [ "mesa" ];
              vulkan.enable = true;
            };
          }
        ];

        "work" = mkHomeConfiguration [
          ./modules/work
        ];
      };
    };
}
