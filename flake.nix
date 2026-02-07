{
  description = "Home Manager personal configuration of southclementide";

  inputs = {
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

    # plasma-manager = {
    #   url = "github:nix-community/plasma-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.home-manager.follows = "home-manager";
    # };
  };

  outputs = { self, nixpkgs, nixgl, home-manager, ... }@inputs:
    let
      # username = "southclementide";
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in
    {
      homeConfigurations = {
        "personal" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [
            (
              let username = "southclementide"; in {
                home = {
                  # Home Manager needs a bit of information about you and the paths it should
                  # manage.
                  inherit username;
                  homeDirectory = "/home/${username}";
                };
              }
            )
            inputs.sops-nix.homeManagerModules.sops
            {
              nixGL = {
                packages = nixgl.packages;
                defaultWrapper = "mesa";
                installScripts = [ "mesa" ];
                vulkan.enable = true;
              };
            }
            ./home.nix
            ./modules/default.nix
          ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
          extraSpecialArgs = {
            inherit inputs;
          };
        };
        "work" = home-manager.lib.homeManagerConfiguration
          {
            inherit pkgs;

            # Specify your home configuration modules here, for example,
            # the path to your home.nix.
            modules = [
              (
                let username = "haoln"; in {
                  home = {
                    # Home Manager needs a bit of information about you and the paths it should
                    # manage.
                    inherit username;
                    homeDirectory = "/home/${username}";
                  };
                }
              )
              inputs.sops-nix.homeManagerModules.sops
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
    };
}
