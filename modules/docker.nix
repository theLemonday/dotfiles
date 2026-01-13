{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dockerfmt
    dockerfile-language-server
    dive
    hadolint
  ];
}
