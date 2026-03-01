{ pkgs, ... }: {
  home.packages = with pkgs;[
    nixpkgs-fmt
    nil # nix language server
  ];
}
