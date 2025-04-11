{ pkgs, ... }: {
  home.packages = [
    pkgs.iproute2
    pkgs.iperf3
  ];
}
