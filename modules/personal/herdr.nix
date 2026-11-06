{ pkgs, ... }: {
  home.packages = with pkgs; [
    herdr
  ];

  programs.herdr.enable = true;

  programs.herdr.settings = {
    terminal = {
      default_shell = "${pkgs.zsh}/bin/zsh";
      new_cwd = "follow";
    };

    ui = {
      sound = {
        enabled = false;
      };
    };

    onboarding = false;
  };

  # Open a pane running opencode with agent detection
  programs.herdr.settings.keys.command = [
    {
      key = "prefix+alt+o";
      type = "pane";
      command = "opencode";
      description = "[O]penCode agent pane";
    }
  ];
}
