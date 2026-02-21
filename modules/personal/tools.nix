{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ast-grep
    gemini-cli
  ];

  programs.ripgrep-all = {
    enable = true;
  };
}
