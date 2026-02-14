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
    ko
  ];

  home.sessionPath = [
    "$HOME/go/bin"
  ];

  programs.go = {
    enable = true;
  };
}
