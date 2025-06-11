{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dotenv-linter
  ];
}
