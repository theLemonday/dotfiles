{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cargo
    rust-analyzer
    rustfmt
    clippy
    rustc
    maturin
  ];

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];
}
