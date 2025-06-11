{ pkgs, ... }:
{
  home.packages = with pkgs;[
    kubectl
    kubecolor
    talosctl
    helm-ls
  ];

  programs.k9s = {
    enable = true;
  };
}
