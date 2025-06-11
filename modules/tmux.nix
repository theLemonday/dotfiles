{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;

    shell = "${pkgs.fish}/bin/fish";

    terminal = "tmux-256color";

    historyLimit = 100000;

    mouse = true;
    keyMode = "vi";
    customPaneNavigationAndResize = true;

    prefix = "C-Space";

    tmuxp.enable = true;

    plugins = with pkgs;[
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.sensible
      tmuxPlugins.yank
      tmuxPlugins.tmux-fzf
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          # set -g @catppuccin_window_left_separator "█"
          # set -g @catppuccin_window_right_separator "█ "
          # set -g @catppuccin_window_number_position "right"
          # set -g @catppuccin_window_middle_separator "  █"
          #
          # set -g @catppuccin_window_default_fill "number"
          #
          # set -g @catppuccin_window_current_fill "number"
          # set -g @catppuccin_window_current_text "#{pane_current_path}"
          #
          # set -g @catppuccin_status_modules_right "application session date_time"
          # set -g @catppuccin_status_left_separator  ""
          # set -g @catppuccin_status_right_separator " "
          # set -g @catppuccin_status_fill "all"
          # set -g @catppuccin_status_connect_separator "yes"
          # set -g status-right-length 100

          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"
          set -g status-left-length 100
          set -g status-left ""
          set -g status-right "#{E:@catppuccin_status_application}"
          set -agF status-right "#{E:@catppuccin_status_cpu}"
          set -ag status-right "#{E:@catppuccin_status_session}"
          set -ag status-right "#{E:@catppuccin_status_uptime}"
          set -agF status-right "#{E:@catppuccin_status_battery}"
        '';
      }
    ];
    extraConfig = ''
      # Undercurl support
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'

      # Auto renumber windows when windows change
      set-option -g renumber-windows on
    '';
  };
}
