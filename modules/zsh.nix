{ pkgs, ... }: {
  # home.packages = with pkgs;[ pure-prompt ];

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    syntaxHighlighting = { enable = true; };
    autosuggestion = { enable = true; };

    autocd = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "docker" "docker-compose" "git" ];
      theme = "";
    };
  };

  programs.fzf.enableZshIntegration = true;

  programs.starship = { enable = true; enableZshIntegration = true; };
}
