{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cargo
  ];

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];
}
