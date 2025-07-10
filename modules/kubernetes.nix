{ pkgs, ... }:
{
  home.packages = with pkgs;[
    kubectl
    talosctl
    helm-ls
    # helm
  ];

  programs.k9s = {
    enable = true;
  };

  programs.kubecolor = {
    enable = true;
    enableAlias = true;
  };
}
