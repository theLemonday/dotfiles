{
  description = "Home Manager configuration of lemonday";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl.url = "github:nix-community/nixGL";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixgl, plasma-manager, ... }@inputs:
    let
      username = "lemonday";
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in
    {
      homeConfigurations."lemonday" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          {
            home = {
              # Home Manager needs a bit of information about you and the paths it should
              # manage.
              inherit username;
              homeDirectory = "/home/${username}";
            };
          }
          inputs.sops-nix.homeManagerModules.sops
          {
            nixGL = {
              packages = nixgl.packages;
              defaultWrapper = "mesa";
              installScripts = [ "mesa" ];
              vulkan.enable = true;
            };
          }
          inputs.plasma-manager.homeManagerModules.plasma-manager
          ./home.nix
          ./modules/default.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };
}
