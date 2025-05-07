{ pkgs, inputs, ... }:
{
  # stable release
  # home.packages = [ pkgs.neovim ];
  home.packages = with pkgs;[ tree-sitter ];

  # nightly release
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default.overrideAttrs (old: {
      meta =
        (old.meta or { })
        // {
          maintainers = old.maintainers or [ ];
        };
    });
    extraLuaPackages = luaPkgs: with luaPkgs; [ xml2lua mimetypes ];
    viAlias = true;
    vimAlias = true;
  };
}
