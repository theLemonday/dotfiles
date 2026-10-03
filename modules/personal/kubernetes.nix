{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kind
  ];
}
