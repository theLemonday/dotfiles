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
        '';
      in
      lib.mkMerge [ config ];
  };

  programs.fzf.enableZshIntegration = true;

  programs.starship = { enable = true; enableZshIntegration = true; };
}

