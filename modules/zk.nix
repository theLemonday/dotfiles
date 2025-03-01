{ pkgs, ... }: {
  home.packages = [
    pkgs.zk
  ];

  # home.file = {
  #   ".config/zk/config.toml" = {
  #     text = (builtins.readFile ../dotfiles/zk.toml);
  #   };
  # };
  xdg.configFile = {
    "zk/config.toml" = {
      source = ../dotfiles/zk.toml;
    };
  };
}
