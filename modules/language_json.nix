{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jq
    nodePackages.vscode-json-languageserver
  ];
}
