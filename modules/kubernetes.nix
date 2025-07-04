{ pkgs, ... }:
{
  home.packages = with pkgs;[
    kubectl
    kubecolor
    talosctl
    helm-ls
    # helm
  ];

  programs.k9s = {
    enable = true;
  };
}
