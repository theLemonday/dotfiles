{ ... }: {
  programs.zsh = {
    enable = false;
    enableCompletion = true;
    autosuggestion.enable = true;

    antidote = {
      enable = true;
      plugins = [
        "zdharma-continuum/fast-syntax-highlighting"
      ];
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
      ];
    };

    #histSize = 10000;
    #histFile = "${config.xdg.dataHome}/zsh/history";
    initExtra = ''
      complete -C /usr/bin/terraform terraform

      function yy() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
      	yazi "$@" --cwd-file="$tmp"
      	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      		builtin cd -- "$cwd"
      	fi
      	rm -f -- "$tmp"
      }
    '';
  };

  # programs.starship = {
  #   enable = false;
  #   # enableZshIntegration = true;
  #   # enableFishIntegration = true;
  #
  #   settings = {
  #     add_newline = true;
  #
  #     # format = "$username$hostname$nix_shell";
  #
  #     username = {
  #       style_user = "bright-white bold";
  #       style_root = "bright-red bold";
  #     };
  #
  #     hostname = {
  #       style = "bright-green bold";
  #       ssh_only = true;
  #     };
  #
  #     nix_shell = {
  #       symbol = "";
  #       format = "[$symbol$name]($style) ";
  #       style = "bright-purple bold";
  #     };
  #   };
  #   # settings = {
  #   #   add_newline = true;
  #   #   format = "$shlvl$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character";
  #   #   shlvl = {
  #   #     disabled = false;
  #   #     symbol = "ﰬ";
  #   #     style = "bright-red bold";
  #   #   };
  #   #   shell = {
  #   #     disabled = false;
  #   #     format = "$indicator";
  #   #     fish_indicator = "";
  #   #     bash_indicator = "[BASH](bright-white) ";
  #   #     zsh_indicator = "[ZSH](bright-white) ";
  #   #   };
  #   #   username = {
  #   #     style_user = "bright-white bold";
  #   #     style_root = "bright-red bold";
  #   #   };
  #   #   hostname = {
  #   #     style = "bright-green bold";
  #   #     ssh_only = true;
  #   #   };
  #   #   nix_shell = {
  #   #     symbol = "";
  #   #     format = "[$symbol$name]($style) ";
  #   #     style = "bright-purple bold";
  #   #   };
  #   #   git_branch = {
  #   #     only_attached = true;
  #   #     format = "[$symbol$branch]($style) ";
  #   #     symbol = "שׂ";
  #   #     style = "bright-yellow bold";
  #   #   };
  #   #   git_commit = {
  #   #     only_detached = true;
  #   #     format = "[ﰖ$hash]($style) ";
  #   #     style = "bright-yellow bold";
  #   #   };
  #   #   git_state = {
  #   #     style = "bright-purple bold";
  #   #   };
  #   #   git_status = {
  #   #     style = "bright-green bold";
  #   #   };
  #   #   directory = {
  #   #     read_only = " ";
  #   #     truncation_length = 0;
  #   #   };
  #   #   cmd_duration = {
  #   #     format = "[$duration]($style) ";
  #   #     style = "bright-blue";
  #   #   };
  #   #   jobs = {
  #   #     style = "bright-green bold";
  #   #   };
  #   #   character = {
  #   #     success_symbol = "[\\$](bright-green bold)";
  #   #     error_symbol = "[\\$](bright-red bold)";
  #   #   };
  #   # };
  # };

}
