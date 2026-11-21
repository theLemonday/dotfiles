{ pkgs, ... }:
let
  # Colours use the terminal's own ANSI palette (names, not 256-colour indexes),
  # so the bar follows whatever theme the terminal applies (darkman light/dark etc).
  mode = "#{?client_prefix,yellow,#{?pane_in_mode,green,blue}}";
  tag = fg: text: "#[fg=${fg}]${text}#[fg=default,nobold,nounderscore]";
  # commas inside a #{?} branch must be written as #,
  esc = builtins.replaceStrings [ "," ] [ "#," ];
in
{
  home.packages = with pkgs;[
    tmux-sessionizer
  ];

  programs.tmux = {
    enable = true;

    terminal = "tmux-256color";
    historyLimit = 100000;
    mouse = true;
    shell = "${pkgs.zsh}/bin/zsh";
    keyMode = "vi";
    customPaneNavigationAndResize = true;

    prefix = "C-Space";

    plugins = with pkgs.tmuxPlugins;[
      # vim-tmux-navigator
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
      ''
        set -g allow-passthrough on

        # Status bar: transparent bar, bold coloured text in terminal ANSI colours, no glyphs, no blocks
        set -g status on
        set -g status-position bottom
        set -g status-interval 5
        set -g status-justify left
        set -g status-style "bg=default,fg=white"
        set -g status-left-length  100
        set -g status-right-length 150

        # Session: coloured by mode (blue normal, yellow prefix held, green copy-mode)
        set -g status-left "${tag mode "#[bold] #S "}#[fg=brightblack]│ "

        set -g window-status-separator "  "
        set -g window-status-style         "none"
        set -g window-status-current-style "none"
        set -g window-status-format         "${tag "brightblack" "#I #W"}"
        set -g window-status-current-format "${tag "magenta" "#[bold]#I #W#{?window_zoomed_flag, Z,}#{?window_bell_flag, !,}"}"
        set -g window-status-bell-style "fg=red,bold"

        # tmux-sessionizer names sessions after the project dir, so skip the path when it equals #S
        set -g status-right "#{?#{==:#S,#{b:pane_current_path}},,${esc "${tag "cyan" "#{b:pane_current_path}"} ${tag "brightblack" "│"} "}}${tag "blue" "#[bold]#h"} "

        # Panes, messages, copy-mode selection
        set -g pane-border-style        "fg=brightblack"
        set -g pane-active-border-style "fg=blue"
        set -g message-style            "bg=default,fg=yellow,bold"
        set -g message-command-style    "bg=default,fg=cyan,bold"
        set -g mode-style               "bg=blue,fg=black"

        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window          -c "#{pane_current_path}"
        unbind '"'
        unbind %

        # Fuzzy session switch
        bind-key C-s display-popup -E "\
          tmux list-sessions -F '#{session_name}' | \
          fzf --reverse --prompt='session> ' | \
          xargs tmux switch-client -t"

        # Fuzzy window switch (across ALL sessions)
        bind-key C-w display-popup -E "\
          tmux list-windows -a -F '#{session_name}:#{window_index} #{window_name} #{s|$HOME|~|:pane_current_path}' | \
          nl -w2 -s'  ' | \
          fzf --reverse --prompt='window> ' | \
          awk '{print \$2}' | \
          xargs -r tmux switch-client -t"

        # last session
        bind C-l switch-client -l

        # Alt+number to jump windows
        # bind -n M-1 select-window -t 1   
        # bind -n M-2 select-window -t 2
        # bind -n M-3 select-window -t 3
        # bind -n M-4 select-window -t 4
        # bind -n M-5 select-window -t 5
        # bind -n M-6 select-window -t 6
        # bind -n M-7 select-window -t 7
        # bind -n M-8 select-window -t 8
        # bind -n M-9 select-window -t 9
      '';
  };
}
