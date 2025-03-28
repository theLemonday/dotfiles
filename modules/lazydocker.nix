{ pkgs }:
let
  version = "0.24.1";
in
{
  home.packages = [
    (pkgs.buildGoModule
      rec {
        pname = "lazydocker";
        inherit version;

        src = pkgs.fetchFromGitHub {
          owner = "jesseduffield";
          repo = "lazydocker";
          rev = "v${version}";
          hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        };

        vendorSha256 = "sha256-bM0lCyeZIwDdK+NXQknxA0NVGvEuIorIv5tLZn9/Of0=";
      })
  ];

}
