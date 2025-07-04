{ pkgs, ... }:
{
  home.packages = with pkgs; [
    go-tools
    go-task
    delve # debugger
    gopls

    # formatter
    gotools
    golines
    gofumpt

    # gopls
  ];

  home.sessionPath = [
    "$HOME/go/bin"
  ];

  programs.go = {
    enable = true;
  };
}
