{ config, pkgs, ... }:
let
  myPython = pkgs.python311;

  # Convert the names to Nix package expressions
  # pythonPackages = builtins.map (name: pkgs.python311Packages.${name}) [
  #   "pip"
  #   "virtualenv"
  #   "numpy"
  #   "pandas"
  #   "requests"
  # ];
  pythonWithPkgs = myPython.withPackages (pythonPkgs: with pythonPkgs; [
    # This list contains tools for Python development.
    # You can also add other tools, like black.
    #
    # Note that even if you add Python packages here like PyTorch or Tensorflow,
    # they will be reinstalled when running `pip -r requirements.txt` because
    # virtualenv is used below in the shellHook.
    ipython
    pip
    setuptools
    virtualenvwrapper
    wheel
  ]);
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "lemonday";
  home.homeDirectory = "/home/lemonday";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # Rust programming language packages
    pkgs.cargo
    pkgs.rustc

    pkgs.tealdeer

    pkgs.lazydocker
    pkgs.neovim
    pkgs.gnumake
    pkgs.nodejs
    pkgs.gcc
    pkgs.ripgrep
    pkgs.nodejs.pkgs.pnpm
    pkgs.unzip

    pythonWithPkgs

    pkgs.shfmt
    # pkgs.python311Packages.pip
    # pkgs.python311Packages.virtualenv
    # pkgs.python311Packages.ipython
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/lemonday/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    antidote = {
      enable = true;
      plugins = [
        "zdharma-continuum/fast-syntax-highlighting"
      ];
    };
    autosuggestion.enable = true;
    #syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza";
      ll = "ls -l";

      update = "sudo nixos-rebuild switch";
      lzd = "lazydocker";
      lzg = "lazygit";
      n = "NVIM_APPNAME='nvim-kickstart' nvim";
      nf = "NVIM_APPNAME='nvim-kickstart' nvim $(fzf)";
      pnpx = "pnpm dlx";
      hm = "home-manager";
      hms = "home-manager switch";
    };
    #histSize = 10000;
    #histFile = "${config.xdg.dataHome}/zsh/history";
    initExtra = ''
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = true;

      # format = "$username$hostname$nix_shell";

      username = {
        style_user = "bright-white bold";
        style_root = "bright-red bold";
      };

      hostname = {
        style = "bright-green bold";
        ssh_only = true;
      };

      nix_shell = {
        symbol = "";
        format = "[$symbol$name]($style) ";
        style = "bright-purple bold";
      };
    };
    # settings = {
    #   add_newline = true;
    #   format = "$shlvl$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character";
    #   shlvl = {
    #     disabled = false;
    #     symbol = "ﰬ";
    #     style = "bright-red bold";
    #   };
    #   shell = {
    #     disabled = false;
    #     format = "$indicator";
    #     fish_indicator = "";
    #     bash_indicator = "[BASH](bright-white) ";
    #     zsh_indicator = "[ZSH](bright-white) ";
    #   };
    #   username = {
    #     style_user = "bright-white bold";
    #     style_root = "bright-red bold";
    #   };
    #   hostname = {
    #     style = "bright-green bold";
    #     ssh_only = true;
    #   };
    #   nix_shell = {
    #     symbol = "";
    #     format = "[$symbol$name]($style) ";
    #     style = "bright-purple bold";
    #   };
    #   git_branch = {
    #     only_attached = true;
    #     format = "[$symbol$branch]($style) ";
    #     symbol = "שׂ";
    #     style = "bright-yellow bold";
    #   };
    #   git_commit = {
    #     only_detached = true;
    #     format = "[ﰖ$hash]($style) ";
    #     style = "bright-yellow bold";
    #   };
    #   git_state = {
    #     style = "bright-purple bold";
    #   };
    #   git_status = {
    #     style = "bright-green bold";
    #   };
    #   directory = {
    #     read_only = " ";
    #     truncation_length = 0;
    #   };
    #   cmd_duration = {
    #     format = "[$duration]($style) ";
    #     style = "bright-blue";
    #   };
    #   jobs = {
    #     style = "bright-green bold";
    #   };
    #   character = {
    #     success_symbol = "[\\$](bright-green bold)";
    #     error_symbol = "[\\$](bright-red bold)";
    #   };
    # };
  };

  programs.go = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    tmux = {
      enableShellIntegration = true;
    };
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = true;
  };

  programs.fd = {
    enable = true;
  };

  programs.bat = {
    enable = true;
    config = {
      style = "plain";
      theme = "TwoDark";
      italic-text = "always";
      pager = "less -FR";
      paging = "never";
    };
  };

  programs.git = {
    enable = true;
    userName = "Lemonday";
    userEmail = "nhathao090703@gmail.com";
  };

  programs.lazygit = {
    enable = true;
  };

  programs.tmux = {
    enable = true;

    shell = "${pkgs.zsh}/bin/zsh";

    terminal = "tmux-256color";

    mouse = true;
    keyMode = "vi";
    customPaneNavigationAndResize = true;

    prefix = "C-Space";

    plugins = with pkgs;[
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.sensible
      tmuxPlugins.yank
      tmuxPlugins.tmux-fzf
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
                  set -g @catppuccin_window_left_separator "█"
          set -g @catppuccin_window_right_separator "█ "
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_middle_separator "  █"

          set -g @catppuccin_window_default_fill "number"

          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#{pane_current_path}"

          set -g @catppuccin_status_modules_right "application session date_time"
          set -g @catppuccin_status_left_separator  ""
          set -g @catppuccin_status_right_separator " "
          set -g @catppuccin_status_fill "all"
          set -g @catppuccin_status_connect_separator "yes"
        '';
      }
    ];
  };
}
