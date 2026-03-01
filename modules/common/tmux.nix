{ pkgs, ... }:
let
  darkPalette = {
    TC = "colour235";
    G1 = "colour239";
    G7 = "colour223";
    G8 = "colour246";
    blue = "colour109";
    yellow = "colour214";
    green = "colour142";
  };
  lightPalette = {
    TC = "colour229";
    G1 = "colour243";
    G7 = "colour235";
    G8 = "colour238";
    blue = "colour24";
    yellow = "colour130";
    green = "colour64";
  };
in
{
  home.file.".config/tmux/theme-apply.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      THEME=$(cat ~/.config/tmux/theme 2>/dev/null || echo dark)
      if [ "$THEME" = "light" ]; then
        tmux set -g status-left    "#[fg=${lightPalette.yellow},bold] #S #[nobold,fg=${lightPalette.G1}]│ "
        tmux set -g status-right   "#[fg=${lightPalette.blue}]$USER#[fg=${lightPalette.G8}]@$HOSTNAME "
        tmux set -g window-status-format         "#[fg=${lightPalette.G1}]#I #[fg=${lightPalette.G8}]#W"
        tmux set -g window-status-current-format "#[fg=${lightPalette.blue},bold,underscore]#I #W"
      else
        tmux set -g status-left    "#[fg=${darkPalette.yellow},bold] #S #[nobold,fg=${darkPalette.G1}]│ "
        tmux set -g status-right   "#[fg=${darkPalette.blue}]$USER#[fg=${darkPalette.G8}]@$HOSTNAME "
        tmux set -g window-status-format         "#[fg=${darkPalette.G1}]#I #[fg=${darkPalette.G8}]#W"
        tmux set -g window-status-current-format "#[fg=${darkPalette.blue},bold,underscore]#I #W"
      fi
    '';
  };
  home.packages = with pkgs;[
    tmux-sessionizer
  ];

  programs.tmux = {
    enable = true;

    terminal = "tmux-256color";
    historyLimit = 100000;
    mouse = true;
    shell = "${pkgs.zsh}/bin/zsh";
    # keyMode = "vi";
    customPaneNavigationAndResize = true;

    prefix = "C-Space";

    plugins = with pkgs.tmuxPlugins;[
      vim-tmux-navigator
      yank
      tmux-fzf
      {
        plugin = fingers;
        extraConfig = ''
          set -g @fingers-hint-style      "fg=colour3,bold"
          set -g @fingers-highlight-style "fg=colour5,bold"
          set -g @fingers-key "f"
        '';
      }
    ];

    extraConfig =
      let
        mkThemeVars = dark: light: key:
          ''set -g @${key} "#{?#{==:#{E:THEME},light},${light.${key}},${dark.${key}}}"'';
        themeVars = builtins.concatStringsSep "\n" (
          map (mkThemeVars darkPalette lightPalette)
            [ "TC" "G1" "G7" "G8" "blue" "yellow" "green" ]
        );
      in
      ''
        # Dark palette - Gruvbox Hard
        set -g @dark-TC     '${darkPalette.TC}'
        set -g @dark-G1     '${darkPalette.G1}'
        set -g @dark-G7     '${darkPalette.G7}'
        set -g @dark-G8     '${darkPalette.G8}'
        set -g @dark-blue   '${darkPalette.blue}'
        set -g @dark-yellow '${darkPalette.yellow}'
        set -g @dark-green  '${darkPalette.green}'

        # Light palette - Gruvbox Material Medium (higher contrast)
        set -g @light-TC     '${lightPalette.TC}'
        set -g @light-G1     '${lightPalette.G1}'
        set -g @light-G7     '${lightPalette.G7}'
        set -g @light-G8     '${lightPalette.G8}'
        set -g @light-blue   '${lightPalette.blue}'
        set -g @light-yellow '${lightPalette.yellow}'
        set -g @light-green  '${lightPalette.green}'

        # Apply theme based on $THEME env var
        ${themeVars}

        # Status bar
        set -g status-style "bg=#{@TC},fg=#{@G8}"
        set -g status-justify left
        set -g status-left-length  100
        set -g status-right-length 150

        # Prefix highlight
        set -g @prefix_highlight_show_copy_mode on
        set -g @prefix_highlight_prefix_prompt 'WAIT'
        set -g @prefix_highlight_copy_prompt   'COPY'
        set -g @prefix_highlight_output_prefix "#[fg=#{@yellow},bold]"
        set -g @prefix_highlight_output_suffix "#[nobold] "
        set -g @prefix_highlight_copy_mode_attr "fg=#{@green},bold"

        # Left — session │ window list
        # set -g status-left "#[fg=#{@yellow},bold] #S #[nobold,fg=#{@G1}]│ "

        # Right — user@host
        # set -g status-right "#[fg=#{@blue}]#{USER}#[fg=#{@G8}]@#H "

        # Window status
        set -g window-status-separator "  "
        # set -g window-status-format         "#[fg=#{@G1}]#I #[fg=#{@G8}]#W"
        # set -g window-status-current-format "#[fg=#{@blue},bold,underscore]#I #W"

        # set -g @fingers-hint-style      "fg=colour3,bold"
        # set -g @fingers-highlight-style "fg=colour5,bold"
        # set -g @fingers-key f

        run-shell "~/.config/tmux/theme-apply.sh"
      '';
  };
}
