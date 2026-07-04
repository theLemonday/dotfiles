{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mbake
    go-task
  ];
}
