{ config, pkgs, ... }:
{
  home.packages = [ (config.lib.nixGL.wrap pkgs.anki) ];

  # Plasma/KRunner's session has neither ~/.nix-profile/bin on PATH nor
  # ~/.nix-profile/share on XDG_DATA_DIRS, so the packaged anki.desktop is
  # invisible. Put an entry with an absolute Exec in ~/.local/share/applications,
  # which is always indexed. (xdg.desktopEntries would land in the profile, not here.)
  xdg.dataFile."applications/anki.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Anki
    GenericName=Flashcards
    Comment=Spaced-repetition memory training program
    Exec=${config.home.profileDirectory}/bin/anki %f
    Icon=${pkgs.anki}/share/icons/hicolor/128x128/apps/anki.png
    Terminal=false
    Categories=Education;Languages;
    MimeType=application/x-colpkg;application/x-apkg;application/x-anki;application/x-ankiaddon;application/vnd.anki;
    StartupWMClass=anki
    SingleMainWindow=true
  '';
}
