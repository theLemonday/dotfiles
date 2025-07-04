{ pkgs, ... }: {
  home.packages = with pkgs; [
    markdownlint-cli

    yaml-language-server
    yamllint
    yamlfix

    # Typst
    tinymist

    # Nix
    nixpkgs-fmt
    nil # nix language server
  ];
}
