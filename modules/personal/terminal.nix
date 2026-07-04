{ pkgs, config, lib, ... }:
let
  themeRepo = pkgs.fetchFromGitHub {
    owner = "kdrag0n";
    repo = "base16-kitty";
    rev = "master";
    hash = "sha256-+vEXvEsar7w7wPVRmKx+rJKUTD5DBgLR7jfl0k7VhnE=";
  };
  themes = {
    dark = "gruvbox-dark-hard";
    light = "gruvbox-material-light-medium";
  };

  # Copy theme file out of the store into a flat derivation.
  # home.file "source" pointing to a plain /nix/store/<hash>/file
  # is still a symlink — wrapping in pkgs.runCommand makes HM
  # write a *copy* because the result path is a direct file, not
  # a directory tree it symlinks into.
  mkThemeFile = name: pkgs.runCommand name { } ''
    cp ${themeRepo}/colors/base16-${name}-256.conf $out
  '';
in
{
  home.packages = with pkgs; [
    wl-clipboard-rs
  ];

  home.sessionVariables = {
    DARK_THEME = themes.dark;
    LIGHT_THEME = themes.light;
  };

  # Use xdg.configFile so everything lives under one namespace.
  # "source" pointing to a flat $out file (not a directory) causes
  # HM to copy rather than symlink.
  xdg.configFile = {
    "kitty/dark-theme.auto.conf".source =
      mkThemeFile themes.dark;
    "kitty/light-theme.auto.conf".source =
      mkThemeFile themes.light;
    "kitty/no-preference-theme.auto.conf".source =
      mkThemeFile themes.light;
  };

  programs.kitty = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.kitty;
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 11;
    };
    enableGitIntegration = true;
    shellIntegration.enableFishIntegration = true;
    extraConfig = ''
      copy_on_select yes
      allow_remote_control yes
      watch_for_file_changes no
    '';
    keybindings = {
      "alt+enter" = "toggle_fullscreen";
    };
  };

  xdg.desktopEntries.kitty = {
    name = "Kitty Terminal";
    genericName = "Terminal Emulator";
    comment = "Fast, feature-rich GPU-based terminal emulator";
    exec = "${pkgs.kitty}/bin/kitty";
    icon = "kitty";
    terminal = false;
    type = "Application";
    categories = [ "System" "TerminalEmulator" ];
  };
}
