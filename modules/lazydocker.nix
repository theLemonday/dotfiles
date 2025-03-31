{ pkgs, ... }:
let
  version = "0.24.1";
in
{
  home.packages = [
    pkgs.lazydocker
    # (pkgs.buildGoModule
    #   rec {
    #     pname = "lazydocker";
    #     inherit version;
    #
    #     src = pkgs.fetchFromGitHub
    #       {
    #         owner = "jesseduffield";
    #         repo = "lazydocker";
    #         rev = "v${version}";
    #         hash = "sha256-cVjDdrxmGt+hj/WWP9B3BT739k9SSr4ryye5qWb3XNM=";
    #       };
    #
    #     vendorHash = "";
    #     # vendorHash = "sha256-cVjDdrxmGt+hj/WWP9B3BT739k9SSr4ryye5qWb3XNM=";
    #   })
  ];

}
