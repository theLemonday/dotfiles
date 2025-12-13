{ config, pkgs, lib, ... }: {
  home.packages = with pkgs;[ pure-prompt ];

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    syntaxHighlighting = { enable = true; };
    autosuggestion = { enable = true; };

    autocd = true;

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
          prompt pure
        '';
        config = lib.mkOrder 1000 '' 
          python_venv() {
            # Supported virtual-env folder names
            for VENV_DIR in ./venv ./.venv; do
              if [[ -d "$VENV_DIR" ]]; then
                # Activate only if not already active,
                # or if the active venv is different
                if [[ "$VIRTUAL_ENV" != "$(realpath "$VENV_DIR")" ]]; then
                  source "$VENV_DIR/bin/activate" >/dev/null 2>&1
                fi
                return
              fi
            done

            # No venv found → deactivate only if one is active
            [[ -n "$VIRTUAL_ENV" ]] && deactivate >/dev/null 2>&1
          }
          autoload -U add-zsh-hook
          add-zsh-hook chpwd python_venv

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
        '';
        lastToRunConfig = lib.mkOrder 1500 ''
          ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
          ZSH_AUTOSUGGEST_USE_ASYNC=1

          # if [ -z "$TMUX" ]; then
          #   tmux attach -t main 2>/dev/null || tmux new -s main
          # fi
          # Silent check: if the agent has no identities, try to add them using the GUI askpass
          ssh-add -l > /dev/null || ssh-add ~/.ssh/id_github

          ZSH_AUTOSUGGEST_STRATEGY=(history completion match_prev_cmd)
        '';
      in
      lib.mkMerge [ earlyConfig beforeCompletionInitialization config lastToRunConfig ];
  };

  programs.fzf.enableZshIntegration = true;

  # home.activation.zshCompile = config.lib.dag.entryAfter [ "writeBoundary" ] ''
  #   # Compile .zshrc if it exists
  #   if [ -f "${config.home.homeDirectory}/.zshrc" ]; then
  #     zsh -fc "zcompile ${config.home.homeDirectory}/.zshrc"
  #   fi
  # '';
  # programs.starship = { enable = true; enableZshIntegration = true; };
}

