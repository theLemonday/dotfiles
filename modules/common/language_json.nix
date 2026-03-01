{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jq
    vscode-langservers-extracted # HTML/CSS/JSON/ESLint language servers
  ];
}
