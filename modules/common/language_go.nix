{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    delve
    gopls

    # formatter
    (lib.lowPrio gotools) # avoid conflict with gopls
    gofumpt
  ];

  home.sessionPath = [
    "$HOME/go/bin"
  ];

  programs.go = {
    enable = true;
  };
}
