{ pkgs, ... }:
{
  home.packages = with pkgs; [
    protoc-gen-go

    go-tools
    # go-task
    delve # debugger
    gopls

    # formatter
    gotools
    golines
    gofumpt

    # gopls
    cobra-cli
  ];

  home.sessionPath = [
    "$HOME/go/bin"
  ];

  programs.go = {
    enable = true;
  };
}
