{ pkgs, helpers, ... }:
{
  home.packages = with pkgs; [
    iproute2
    iperf3
    websocat

    (helpers.mkPodmanWrapper {
      name = "nmap";
      # This image is extremely lightweight and purpose-built as an nmap wrapper
      image = "docker.io/instrumentisto/nmap";
      volumes = [
        # Optional: mount a local directory if you want to output scan results to a file (e.g., -oN)
        "$PWD:/workdir"
      ];
      extraArgs = [
        "--net=host"
        "--cap-add=NET_RAW" # The VIP pass required for SYN scans (-sS) and OS detection (-O)
        "-w /workdir"
      ];
    })
  ];
}
