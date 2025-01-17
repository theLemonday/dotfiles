{ pkgs, inputs, ... }:
{
  # stable release
  home.packages = [ pkgs.neovim ];

  # nightly release
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    extraLuaPackages = luaPkgs: with luaPkgs; [ xml2lua mimetypes ];
  };
}
