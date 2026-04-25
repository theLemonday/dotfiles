{ pkgs, ... }:
{
  home.packages = with pkgs;[ tree-sitter ];

  # nightly release
  programs.neovim = {
    enable = true;
    #    extraLuaPackages = luaPkgs: with luaPkgs; [ mimetypes ];
    viAlias = true;
    vimAlias = true;
    # package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
    withPython3 = false;
    withRuby = false;
  };
}
