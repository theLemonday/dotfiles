let
  mpdSocketPath = "~/.config/mpd/socket";
in
{
  programs.rmpc = {
    enable = true;
    config = ''
      (
        address: "${mpdSocketPath}",
        cache_dir: Some("~/.cache/rmpc/"),
      )
    '';
  };

  services.mpd = {
    enable = true;
    extraConfig = ''
      bind_to_address "${mpdSocketPath}"
    '';
  };
}
