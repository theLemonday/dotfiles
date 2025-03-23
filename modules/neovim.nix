{ pkgs, inputs, ... }:
let
  neovim-nightly =
    (builtins.getFlake "github:nix-community/neovim-nightly-overlay").packages.${pkgs.system}.default;
in
{
  # stable release
  home.packages = [ pkgs.neovim ];

  # nightly release
  programs.neovim = {
    enable = true;
    # package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    package = neovim-nightly;
    extraLuaPackages = luaPkgs: with luaPkgs; [ xml2lua mimetypes ];
  };
}
