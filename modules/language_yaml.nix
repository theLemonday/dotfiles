{ pkgs, ... }:
{
  home.packages = with pkgs; [
    yaml-language-server
    yamllint
    yamlfix
  ];
}
