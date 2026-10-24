{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    ast-grep

    (config.lib.nixGL.wrap anki)
  ];

  programs.ripgrep-all = {
    enable = true;
  };

  programs.mpv = {
    enable = true;
    scripts = [ pkgs.mpvScripts.uosc ];
  };
}
