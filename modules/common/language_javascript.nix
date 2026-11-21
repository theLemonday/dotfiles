{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_22
    pnpm
  ];

  # Global pnpm installs (e.g. @opencode/cli) live outside the nix store.
  home.sessionVariables.PNPM_HOME = "${config.xdg.dataHome}/pnpm";
  home.sessionPath = [ "${config.xdg.dataHome}/pnpm" ];
}
