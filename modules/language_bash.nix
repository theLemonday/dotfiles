{ pkgs, ... }:
{
  home.packages = with pkgs; [
    shfmt
    # bashdb
    shellcheck
  ];
}
