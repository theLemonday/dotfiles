{ pkgs, ... }:
{
  home.packages = with pkgs; [
    go-tools
    delve
    gopls

    # formatter
    gotools
    golines
    gofumpt
  ];

  home.sessionPath = [
    "$HOME/go/bin"
  ];

  programs.go = {
    enable = true;
  };
}
