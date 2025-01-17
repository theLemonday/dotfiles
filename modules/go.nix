{ pkgs, ... }:
{
  home.packages = [
    pkgs.go-tools
    pkgs.go-task
  ];

  programs.go = {
    enable = true;
  };
}
