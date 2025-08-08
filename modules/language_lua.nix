{ pkgs, ... }:
{
  home.packages = with pkgs; [
    stylua
    lua5_1
    lua-language-server
  ];
}
