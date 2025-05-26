{ pkgs, ... }:
{
  home.packages = with pkgs; [
    go-tools
    go-task
    delve # debugger
    gopls

    # formatter
    # golines
    # gofumpt
    # goimports

    # gopls
  ];

  home.sessionPath = [
    "$HOME/go/bin"
  ];

  programs.go = {
    enable = true;
  };
}
