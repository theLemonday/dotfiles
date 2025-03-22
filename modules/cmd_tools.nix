{ pkgs, ... }:
{
  home.packages = [
    pkgs.ripgrep
  ];

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;

    # settings = {
    #   manager = {
    #     show_hidden = true;
    #   };
    # };

    shellWrapperName = "yy";
  };

  programs.yt-dlp = {
    enable = true;
  };

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
    icons = "auto";
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
