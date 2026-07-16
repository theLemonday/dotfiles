{ pkgs, ... }:
{
  home.packages = with pkgs; [
    yq-go
    yaml-language-server
    yamllint
  ];
}
