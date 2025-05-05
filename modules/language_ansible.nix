{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vscode-extensions.redhat.ansible
    ansible
  ];

}
