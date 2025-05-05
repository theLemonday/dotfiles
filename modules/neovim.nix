{ pkgs, inputs, ... }:
{
  # stable release
  # home.packages = [ pkgs.neovim ];

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

  };
}
