{ pkgs, ... }:
with pkgs;
let
  R-with-packages = rWrapper.override { packages = with rPackages; [ ggplot2 dplyr xts languageserver styler ]; };
in
{
  home.packages = [
    R-with-packages
  ];
}
