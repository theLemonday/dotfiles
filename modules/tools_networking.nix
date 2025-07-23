{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    iproute2
    iperf3
    websocat
    nmap
    inetutils
    bettercap
    containerlab
  ];

  home.activation.containerlabFishCompletion = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.config/fish/completions"
    containerlab completion fish > "$HOME/.config/fish/completions/containerlab.fish"
  '';

}
