{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dockerfmt
    kind
    # docker-compose
    lazydocker
    dockerfile-language-server
  ];
}
