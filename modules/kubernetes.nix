{ pkgs, ... }:
{
  home.packages = with pkgs;[
    kubectl
    kubecolor
    talosctl
  ];

  programs.k9s = {
    enable = true;
  };
}
