{ config, pkgs, ... }:

let
  deleteOldCloudtts = pkgs.writeShellScript "delete-cloudtts-old-files" ''
    find ~/Downloads/ -name 'cloudtts-com*' -type f -mtime +0 -delete
  '';
in
{
  systemd.user.services.deleteOldCloudtts = {
    Unit = {
      Description = "Delete old cloudtts-com* files";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${deleteOldCloudtts}";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.timers.deleteOldCloudtts = {
    Unit = {
      Description = "Run deleteOldCloudtts daily";
    };
    Timer = {
      OnCalendar = "daily";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  services.darkman = {
    enable = true;
    settings = {
      # Website to find location: https://www.latlong.net/
      lat = 21.028511;
      lng = 105.804817;
      portal = true;
    };

    # Can be test with: darkman set [dark|light], remember: if new mode = current mode, the scripts are not executed
    lightModeScripts = {
      set-theme = ''
        export XDG_RUNTIME_DIR="/run/user/$(id -u)"
        export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
        export WAYLAND_DISPLAY="wayland-0"      # if using Wayland
        lookandfeeltool -a org.kde.breeze.desktop
        plasma-apply-colorscheme BreezeLight
        plasma-apply-desktoptheme Breeze
        notify-send "KDE Theme" "Switched to Breeze Light 🌞"
        export K9S_SKIN="gruvbox-material-light-soft"
      '';
    };
    darkModeScripts = {
      set-theme = ''
        export XDG_RUNTIME_DIR="/run/user/$(id -u)"
        export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
        export WAYLAND_DISPLAY="wayland-0"      # if using Wayland
        lookandfeeltool -a org.kde.breezedark.desktop
        plasma-apply-colorscheme BreezeDark
        lookandfeeltool -a org.kde.breezedark
        notify-send "KDE Theme" "Switched to Breeze Dark 🌙"
        export K9S_SKIN="gruvbox-material-dark-soft"
      '';
    };
  };
}
