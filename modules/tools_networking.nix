{ pkgs, ... }:
let

in
{
  home.packages = with pkgs; [
    iproute2
    iperf3
    websocat
    nmap
    inetutils
    bettercap
  ];
}
