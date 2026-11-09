{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cargo
    rust-analyzer
    rustfmt
    clippy
    rustc
  ];

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];
}
