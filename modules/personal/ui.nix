{ pkgs, ... }: {
  home.packages = with pkgs;[
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    imagemagick

    ffmpeg_7-full
  ];

  fonts.fontconfig.enable = true;
}
