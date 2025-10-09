{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # docker-compose
    lazydocker
    dockerfile-language-server
  ];
}
