{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dockerfmt
    kind
    dockerfile-language-server
    dive
    hadolint
  ];
}
