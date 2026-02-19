{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ast-grep
    bpftrace
  ];

  programs.ripgrep-all = {
    enable = true;
  };
}
