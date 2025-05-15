{ pkgs, ... }: {
  home.packages = with pkgs; [
    iproute2
    iperf3
    websocat
  ];
}
