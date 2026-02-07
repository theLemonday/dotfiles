{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cargo
    rustc
  ];

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];
}
