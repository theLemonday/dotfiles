{ pkgs, ... }: {
  # home.packages = with pkgs;[
  # ];
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 11;
    };

    enableGitIntegration = true;
    shellIntegration.enableFishIntegration = true;

    extraConfig = ''
      copy_on_select yes
    '';

    keybindings = {
      "alt+enter" = "toggle_fullscreen";
    };
  };
}
