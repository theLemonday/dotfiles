{ pkgs, ... }: {
  home.packages = with pkgs; [
    nodejs_22 # LTS is usually best for system work
    corepack_22 # Manages pnpm/yarn without global installs
    typescript # The tsc compiler

    dprint # Faster, Rust-based alternative to Prettier
    vue-language-server
    typescript-language-server
  ];

  # Optional: Environment variables for JS tooling
  home.sessionVariables = {
    NODE_PATH = "$HOME/.node_libraries";
  };

  home.file.".local/share/vue-plugin/node_modules/@vue/typescript-plugin".source =
    "${pkgs.vue-language-server}/lib/language-tools/packages/typescript-plugin";
}
