{ pkgs, ... }:
{
  home.packages = with pkgs;[
    argocd
  ];
}
