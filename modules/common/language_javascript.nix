{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Runtimes & Core Tools
    nodejs_22 # LTS is usually best for system work
    corepack_22 # Manages pnpm/yarn without global installs
    typescript # The tsc compiler

    # Modern standard library / alternate runtime
    bun # Extremely fast for scripting (Go-like speed)

    # Tooling
    dprint # Faster, Rust-based alternative to Prettier
    vtsls # A faster LSP for TS than the default tsserver
    prettierd
  ];

  # Optional: Environment variables for JS tooling
  home.sessionVariables = {
    NODE_PATH = "$HOME/.node_libraries";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.cache/.bun/bin"
  ];
}
