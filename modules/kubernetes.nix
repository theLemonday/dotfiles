{ lib, pkgs, ... }:
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

  home.sessionVariables = {
    KUBECOLOR_PRESET = "light";
  };
  programs.kubecolor = {
    enable = true;
    enableAlias = true;
    settings = {
      kubectl = lib.getExe pkgs.kubectl;
      preset = "dark";
    };
  };
}
