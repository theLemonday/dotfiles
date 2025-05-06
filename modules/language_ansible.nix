{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vscode-extensions.redhat.ansible
    ansible
    ansible-lint
    ansible-language-server
  ];
}
