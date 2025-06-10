{ pkgs, ... }:
{
  home.packages = with pkgs; [
    sql-formatter
  ];
}
