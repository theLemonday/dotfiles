{ pkgs, ... }:
{
  home.packages = [
    pkgs.kubectl
  ];

  programs.k9s = {
    enable = true;
  };
}
