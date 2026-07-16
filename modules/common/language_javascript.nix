{ pkgs, ... }: {
  home.packages = with pkgs; [
    nodejs_22 # LTS is usually best for system work
    corepack_22 # Manages pnpm/yarn without global installs
    typescript # The tsc compiler

    dprint # Faster, Rust-based alternative to Prettier
    vtsls # A faster LSP for TS than the default tsserver
  ];

  # Optional: Environment variables for JS tooling
  home.sessionVariables = {
    NODE_PATH = "$HOME/.node_libraries";
  };

}
