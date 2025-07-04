{ pkgs, ... }:
let
  themeRepo = pkgs.fetchFromGitHub {
    owner = "adi1090x";
    repo = "rofi";
    rev = "master";
    hash = "sha256-yMKpwxdwvp7ryz2XXunbjC/5ud9HHEDzyYRhM540958=";
  };
in
{
  home.packages = with pkgs;[
    iproute2
    iperf3
    websocat
    nmap
    inetutils
  ];

  programs.rofi = {
    enable = true;
  };

  home.file.".config/rofi/" = {
    source = "${themeRepo}/files";
    recursive = true;
  };
}
