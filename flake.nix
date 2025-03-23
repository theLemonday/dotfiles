{
  description = "Home Manager configuration of lemonday";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    tmux-sessionx = {
      url = "github:omerxx/tmux-sessionx";
    };

    yazi.url = "github:sxyazi/yazi";

    templ.url = "github:a-h/templ";
  };

  outputs = { self, nixpkgs, home-manager, yazi, ... }@inputs:
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
          ./home.nix
          ./modules/default.nix
          ({ pkgs, ... }: {
            home.packages = [ yazi.packages.${pkgs.system}.default ];
          })
          {
            nixpkgs.overlays = [
              inputs.templ.overlays.default
              # inputs.neovim-nightly-overlay.overlays.default
              inputs.yazi.overlays.default
            ];
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
