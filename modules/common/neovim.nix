{ pkgs, inputs, ... }:
{
  home.packages = with pkgs;[ tree-sitter ];

  # nightly release
  programs.neovim = {
    enable = true;
    #    extraLuaPackages = luaPkgs: with luaPkgs; [ mimetypes ];
    viAlias = true;
    vimAlias = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
  };
}
