{ pkgs, ... }:
{
  home.packages = with pkgs; [
  dockerfmt
    # docker-compose
    lazydocker
    dockerfile-language-server
  ];
}
