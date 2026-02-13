{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ast-grep
  ];

  programs.ripgrep-all = {
    enable = true;
  };
}
