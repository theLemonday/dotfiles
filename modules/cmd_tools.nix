{ pkgs, ... }:
{
  home.packages = [ pkgs.ripgrep ];

  programs.fzf = {
    enable = true;
    # enableZshIntegration = true;
    enableFishIntegration = true;

    tmux = {
      enableShellIntegration = true;
    };
  };

  programs.eza = {
    enable = true;
    # enableZshIntegration = true;
    enableFishIntegration = true;
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
}
