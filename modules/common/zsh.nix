{ config, pkgs, lib, ... }:
let
  autoload_python_venv = ''
    auto_source_venv() {
      # Check if we are inside a git directory
      local gitdir
      gitdir=$(git rev-parse --show-toplevel 2>/dev/null)

      if [[ -n "$gitdir" ]]; then
        gitdir=$(realpath "$gitdir")
        local cwd=$(pwd -P)

        # Walk up until we leave the git root
        while [[ "$cwd" == "$gitdir"* ]]; do
          if [[ -f "$cwd/.venv/bin/activate" ]]; then
            source "$cwd/.venv/bin/activate" &>/dev/null
            return
          elif [[ -f "$cwd/venv/bin/activate" ]]; then
            source "$cwd/venv/bin/activate" &>/dev/null
            return
          fi
          cwd="''${cwd%/*}"
          [[ -z "$cwd" ]] && break
        done
      fi

      # Deactivate if no venv applies anymore
      if [[ -n "$VIRTUAL_ENV" ]]; then
        deactivate
      fi
    }

    autoload -Uz add-zsh-hook
    add-zsh-hook chpwd auto_source_venv

    # Run once on shell startup
    auto_source_venv
  '';

  bat_help_alias = ''
    alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
    alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
  '';

  enable_vi_mode = ''
    # Enable vi keybindings
    bindkey -v

    # Show mode in prompt (vi-mode indicator)
    function zle-keymap-select {
      zle reset-prompt
    }
    zle -N zle-keymap-select

    # Make Ctrl-A / Ctrl-E still work in vi mode
    bindkey -M vicmd '^A' beginning-of-line
    bindkey -M vicmd '^E' end-of-line
  '';
in
{
  home.packages = with pkgs;[ pure-prompt ];

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    syntaxHighlighting = { enable = true; };
    autosuggestion = { enable = true; };

    autocd = true;

    dotDir = "${config.xdg.configHome}/zsh";

    oh-my-zsh = {
      enable = true;
      plugins = [ "docker" "docker-compose" "git" "fzf" "eza" ];
      theme = "";
    };

    shellGlobalAliases = {
      "-h" = "-h 2>&1 | bat --language=help --style=plain";
      "--help" = "--help 2>&1 | bat --language=help --style=plain";
    };

    initContent =
      let
        earlyConfig = lib.mkOrder 500 ''
          DISABLE_AUTO_UPDATE="true"
          DISABLE_MAGIC_FUNCTIONS="true"
          DISABLE_COMPFIX="true"
        '';
        beforeCompletionInitialization = lib.mkOrder 550 ''
          # Cache completions aggressively
          autoload -Uz compinit
          if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
              compinit
          else
              compinit -C
          fi

          autoload -U promptinit; promptinit

          PURE_GIT_UNSTAGED_DIRTY='*'
          PURE_GIT_STAGED_DIRTY='+'
          PURE_GIT_UNTRACKED_DIRTY='?'
          PURE_GIT_SHOW_DIRTY=true
          PURE_GIT_SHOW_DETAILS=true
          prompt pure
        '';
        config = lib.mkOrder 1000
          (autoload_python_venv + bat_help_alias + '' 
          # Make aliases expand automatically when you press <space>, <s-tab>
          # Inside incremental search, space behaves normally
          globalias() {
             if [[ $LBUFFER =~ '[a-zA-Z0-9]+$' ]]; then
                 zle _expand_alias
                 zle expand-word
             fi
             zle self-insert
          }
          zle -N globalias

          bindkey " " globalias
          bindkey "^[[Z" magic-space
          bindkey -M isearch " " magic-space

          # -s means "string": it simulates typing the text
          # ^f represents Ctrl+f
          # \n represents the Enter key
          # bindkey -s ^s "tmux-sessionizer\n"
          # -r means "repeatable" (optional, allows you to hit 'f' multiple times)
          # run-shell executes a command in the background
          # "tmux neww" opens a temporary window to run the script
          bindkey -r s run-shell "tmux neww tmux-sessionizer"
        '');
        lastToRunConfig = lib.mkOrder 1500 ''
          ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
          ZSH_AUTOSUGGEST_USE_ASYNC=1

          # if [ -z "$TMUX" ]; then
          #   tmux attach -t main 2>/dev/null || tmux new -s main
          # fi
          # Silent check: if the agent has no identities, try to add them using the GUI askpass
          ssh-add -l > /dev/null || ssh-add ~/.ssh/id_github

          ZSH_AUTOSUGGEST_STRATEGY=(history completion match_prev_cmd)

          # Define the directory where you keep your split configs
          ZSH_CONFIG_DIR="$HOME/.config/zsh/conf.d"

          # 1. Check if directory exists
          if [ -d "$ZSH_CONFIG_DIR" ]; then
            # 2. Loop through every file ending in .zsh
            for config_file in "$ZSH_CONFIG_DIR"/*.zsh; do
              # 3. Source (load) the file
              source "$config_file"
            done
          fi
        '';
      in
      lib.mkMerge [ earlyConfig beforeCompletionInitialization config lastToRunConfig ];
  };

  programs.fzf.enableZshIntegration = true;
}
