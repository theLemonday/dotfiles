{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    syntaxHighlighting = { enable = true; };
    autosuggestion = { enable = true; };

    autocd = true;
  };

  programs.fzf.enableZshIntegration = true;
}
