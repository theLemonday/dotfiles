{ pkgs, lib, ... }: {
  # home.packages = with pkgs;[ pure-prompt ];

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
        '';
        config = lib.mkOrder 1000 '' 
          python_venv() {
            MYVENV=./venv
            # when you cd into a folder that contains $MYVENV
            [[ -d $MYVENV ]] && source $MYVENV/bin/activate > /dev/null 2>&1
            # when you cd into a folder that doesn't
            [[ ! -d $MYVENV ]] && deactivate > /dev/null 2>&1
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
        '';
      in
      lib.mkMerge [ earlyConfig beforeCompletionInitialization config lastToRunConfig ];
  };

  programs.fzf.enableZshIntegration = true;

  programs.starship = { enable = true; enableZshIntegration = true; };
}

