{
  programs.rmpc = {
    enable = true;
  };

  services.mpd = {
    enable = true;
    musicDirectory = "~/music";
  };
}
