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
}

