{ lib, pkgs, ... }:
let
  k9sSrc = pkgs.fetchFromGitHub {
    owner = "derailed";
    repo = "k9s";
    rev = "master";
    sha256 = "sha256-PYaVzUAQuy5LBkyJ3otWX1iRYWSkt4sD3HIvpGTOiQY="; # replace after first build
  };
in
{
  home.packages = with pkgs;[
    kubectl
    talosctl
    helm-ls
    # helm
    kubectx
    kustomize
    stern
    kube-score
    kubectl-tree
  ];

  home.file.".config/k9s/skins" = {
    source = "${k9sSrc}/skins";
    recursive = true;
  };
  programs.k9s = {
    enable = true;
    settings = {
      k9s = {
        ui = {
          skin = "transparent";
        };
      };
    };
  };

  home.sessionVariables = {
    KUBECOLOR_PRESET = "dark";
  };
  programs.kubecolor = {
    enable = true;
    enableAlias = true;
    settings = {
      kubectl = lib.getExe pkgs.kubectl;
      preset = "dark";
    };
  };

  programs.kubeswitch = {
    enable = true;
    enableFishIntegration = true;
  };
}
