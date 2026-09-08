{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ast-grep
  ];

  programs.ripgrep-all = {
    enable = true;
  };

  programs.mpv = {
    enable = true;
    scripts = [ pkgs.mpvScripts.uosc ];
  };
}
