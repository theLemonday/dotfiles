{ pkgs, config, ... }:
let
  themeRepo = pkgs.fetchFromGitHub {
    owner = "kdrag0n";
    repo = "base16-kitty";
    rev = "master";
    hash = "sha256-+vEXvEsar7w7wPVRmKx+rJKUTD5DBgLR7jfl0k7VhnE=";
  };

  # Default: light theme (no-preference = light)
  themes = {
    dark = "gruvbox-dark-hard";
    light = "gruvbox-material-light-medium";
  };
in
{
  home.packages = with pkgs;[
    wl-clipboard-rs
  ];

  home.sessionVariables = {
    "DARK_THEME" = themes.dark;
    "LIGHT_THEME" = themes.light;
  };

  home.file = {
    ".config/kitty/dark-theme.auto.conf" = {
      source = "${themeRepo}/colors/base16-${themes.dark}-256.conf";
    };
    ".config/kitty/light-theme.auto.conf" = {
      source = "${themeRepo}/colors/base16-${themes.light}-256.conf";
    };
    ".config/kitty/no-preference-theme.auto.conf" = {
      source = "${themeRepo}/colors/base16-${themes.light}-256.conf";
    };
  };

  programs.kitty = {
    enable = true;
    package = (config.lib.nixGL.wrap pkgs.kitty);

    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 11;
    };

    enableGitIntegration = true;
    shellIntegration.enableFishIntegration = true;

    extraConfig = ''
      copy_on_select yes

      allow_remote_control yes
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
    icon = "kitty"; # Uses system-installed icon if available
    terminal = false;
    type = "Application";
    categories = [ "System" "TerminalEmulator" ];
  };
}
