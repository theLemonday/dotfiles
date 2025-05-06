{ pkgs, ... }: {
  home.packages = with pkgs; [
    zk
    markdownlint-cli
  ];

  xdg.configFile = {
    "zk/config.toml" = {
      source = ../dotfiles/zk.toml;
    };
  };
}
