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

    plugins = with pkgs.tmuxPlugins;[
      vim-tmux-navigator
      sensible
      yank
      tmux-fzf
      {
        plugin = fingers;
        extraConfig = ''
          # Unbind the default prefix + f
          unbind-key s

          set -g @fingers-key s
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

      set -g @TC  'colour18'
      set -g @G0  'colour00'
      set -g @G1  'colour01'
      set -g @G2  'colour02'
      set -g @G3  'colour03'
      set -g @G4  'colour04'
      set -g @G5  'colour05'
      set -g @G7  'colour07'
      set -g @G8 	'colour08'

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

  programs.zellij = {
    # enable = true;
    enableFishIntegration = true;
    settings = {
      ui = {
        show_keybinds = false;
      };
    };
  };
}

