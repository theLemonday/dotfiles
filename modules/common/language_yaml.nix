{ pkgs, ... }:
{
  home.packages = with pkgs; [
    yq
    yaml-language-server
    yamllint
    yamlfix
  ];
}
