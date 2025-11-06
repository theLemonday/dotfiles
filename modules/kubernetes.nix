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
  ];

  home.file.".config/k9s/skins" = {
    source = "${k9sSrc}/skins";
    recursive = true;
  };
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
