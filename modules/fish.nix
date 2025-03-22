{ pkgs, lib, ... }:
let
  kubecolorSetup = ''
    # adds alias for "kubectl" to "kubecolor" with completions
    function kubectl --wraps kubectl
      command kubecolor $argv
    end

    # adds alias for "k" to "kubecolor" with completions
    function k --wraps kubectl
      command kubecolor $argv
    end

    # reuse "kubectl" completions on "kubecolor"
    function kubecolor --wraps kubectl
      command kubecolor $argv
    end
  '';

  tideSetup = ''
    tide configure --auto --style=Lean --prompt_colors='True color' --show_time=No --lean_prompt_height='Two lines' --prompt_connection=Solid --prompt_connection_andor_frame_color=Darkest --prompt_spacing=Sparse --icons='Few icons' --transient=Yes
  '';
in
{
  home.packages = [
    pkgs.fishPlugins.fzf-fish
    pkgs.fishPlugins.autopair
    pkgs.fishPlugins.tide
    pkgs.fishPlugins.z
  ];

  programs.fish = {
    enable = true;
    shellInit = lib.strings.concatStrings [
      tideSetup
      ''
        just --completions fish > ~/.config/fish/completions/just.fish

        # Define the alias for bathelp
        function bathelp
            bat --plain --language=cmd-help $argv
        end

        # Define the help function
        function help
            set -o pipefail
            # Execute the command passed as arguments with --help and pipe to bathelp
            $argv --help 2>&1 | bathelp
        end

        # For every command end with "--help", apply bat color
        function run
          if contains -- "--help" $argv
              eval "$argv 2>&1 | bat --language=help --style=plain"
          else
              eval $argv
          end
        end

        export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
      ''
      kubecolorSetup
    ];
    interactiveShellInit = ''
      # Based on https://gist.github.com/bastibe/c0950e463ffdfdfada7adf149ae77c6f
      # Changes:
      # * Instead of overriding cd, we detect directory change. This allows the script to work
      #   for other means of cd, such as z.
      # * Update syntax to work with new versions of fish.
      # * Handle virtualenvs that are not located in the root of a git directory.

      function __auto_source_venv --on-variable PWD --description "Activate/Deactivate virtualenv on directory change"
        status --is-command-substitution; and return

        # Check if we are inside a git directory
        if git rev-parse --show-toplevel &>/dev/null
          set gitdir (realpath (git rev-parse --show-toplevel))
          set cwd (pwd -P)
          # While we are still inside the git directory, find the closest
          # virtualenv starting from the current directory.
          while string match "$gitdir*" "$cwd" &>/dev/null
            if test -e "$cwd/.venv/bin/activate.fish"
              source "$cwd/.venv/bin/activate.fish" &>/dev/null 
              return
            else
              set cwd (path dirname "$cwd")
            end
          end
        end
        # If virtualenv activated but we are not in a git directory, deactivate.
        if test -n "$VIRTUAL_ENV"
          deactivate
        end
      end
    '';
  };
}
