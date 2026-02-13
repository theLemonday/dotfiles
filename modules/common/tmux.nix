{ pkgs, ... }:
let
  # We define the script as a package
  tmux-sessionizer = pkgs.writeShellScriptBin "tmux-sessionizer" ''
    # Note: In Nix, we usually hardcode the binary paths or ensure they are in the PATH
    # The 'lib.makeBinPath' is the most robust way, but for a simple script, 
    # relying on the user environment is okay if you add packages to home.packages.
    
    # 1. Define paths
    search_paths=("$HOME/Documents" "$HOME/Documents/code")

    # 2. Use fd (Nix usually provides 'fd', not 'fdfind')
    if [[ $# -eq 1 ]]; then
        selected=$1
    else
        # We use ${pkgs.fd}/bin/fd to ensure we use the Nix version
        selected=$(${pkgs.fd}/bin/fd --min-depth=1 --max-depth=1 --type=d --full-path . "''${search_paths[@]}" | ${pkgs.fzf}/bin/fzf)
    fi

    if [[ -z $selected ]]; then
        exit 0
    fi

    session_name=$(basename "$selected" | tr . _)

    # Check if tmux is running
    # We use explicit paths for robustness
    tmux_running=$(${pkgs.procps}/bin/pgrep tmux)

    if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
        ${pkgs.tmux}/bin/tmux new-session -s "$session_name" -c "$selected"
        exit 0
    fi

    if ! ${pkgs.tmux}/bin/tmux has-session -t="$session_name" 2> /dev/null; then
        ${pkgs.tmux}/bin/tmux new-session -ds "$session_name" -c "$selected"
    fi

    if [[ -n $TMUX ]]; then
        ${pkgs.tmux}/bin/tmux switch-client -t "$session_name"
    else
        ${pkgs.tmux}/bin/tmux attach-session -t "$session_name"
    fi
  '';
in
{
  home.packages = with pkgs; [
    tmux-sessionizer
  ];

  programs.tmux = {
    enable = true;

    terminal = "tmux-256color";
    historyLimit = 100000;
    mouse = true;
    keyMode = "vi";
    customPaneNavigationAndResize = true;

    prefix = "C-Space";

    plugins = with pkgs.tmuxPlugins;[
      vim-tmux-navigator
      sensible
      yank
      tmux-fzf
      {
        plugin = fingers;
        extraConfig = ''
          # Unbind the default prefix + f
          unbind-key f

          set -g @fingers-key f
        '';
      }
    ];
    extraConfig = ''
      # Undercurl support
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'

      # Status options
      set -g status-interval 5
      set -g status on

      # Icons
      set -g @r_sep              	" " # 
      set -g @l_sep              	" " # 
      set -g @upload_speed_icon   "󰕒"
      set -g @download_speed_icon "󰇚"
      set -g @session_icon        ""
      set -g @user_icon           "" #     
      set -g @time_icon           ""
      set -g @date_icon           ""
      set -g @directory_icon 		"" # 

      # Format strings with fallback
      set -g @prefix_highlight_pos "#{E:@status_line_prefix_highlight_pos,}"
      set -g @time_format          "#{E:@status_line_time_format,%T}"
      set -g @date_format          "#{E:@status_line_date_format,%F}"

      set -g @TC 'colour18'
      set -g @G0 'colour00'
      set -g @G1 'colour01'
      set -g @G2 'colour02'
      set -g @G3 'colour03'
      set -g @G4 'colour04'
      set -g @G5 'colour05'
      set -g @G7 'colour07'
      set -g @G8 'colour08'

      ##### Basic status bar #####
      set -gF status-style "bg=#{@TC},fg=#{@G4}"

      ##### Prefix highlight plugin #####
      set -g @prefix_highlight_show_copy_mode on
      set -gF @prefix_highlight_copy_mode_attr "fg=#{@TC},bg=#{@G0},bold"
      set -gF @prefix_highlight_output_prefix "#[fg=#{@TC}]#[bg=#{@G0}]#{@l_sep}#[bg=#{@TC}]#[fg=#{@G0}]"
      set -gF @prefix_highlight_output_suffix "#[fg=#{@TC}]#[bg=#{@G0}]#{@r_sep}"

      ##### Status-left settings #####
      # set -g status-left-bg "#{@G0}"
      set -g status-left-length 150

      # #{@section_user_host}
      set -g @section_user "#[bg=#{@G7},fg=#{@G0},bold] #{@user_icon} #(whoami)"
      set -gF @section_host "#[bg=#{@G7},fg=#{@G0},bold]#H "

      set -g @section_session "#[bg=#{@G7},fg=#{@G0}] #S "
      set -gF status-left "#{@section_session}#[bg=default,fg=default] "

      # set -g window-status-separator ""

      # set -g window-status-current-format "#[bg=#{@G2},fg=#{@G8}] #I:#W #[default]"

      # set -g window-status-format "#[bg=#{@G8},fg=#{@G7}] #I:#W "

      set -g @current_path "#[bg=#{@G8},fg=#{@G7}] #{@directory_icon} #{pane_current_path}"
      set -gF status-right "#{@current_path} #{@section_user}@#{@section_host}"
    '';
  };
}
