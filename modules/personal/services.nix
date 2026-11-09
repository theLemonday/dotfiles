{ config, pkgs, ... }:

let
  deleteOldCloudtts = pkgs.writeShellScript "delete-cloudtts-old-files" ''
    find ~/Downloads/ -name 'cloudtts-com*' -type f -mtime +0 -delete
  '';

  # Auto-push the home-manager config when the current branch has unpushed
  # commits that are at least 2 days old. Only pushes if the branch already
  # has a remote + merge target configured (no upstream guessing).
  autoPushOldCommits = pkgs.writeShellScript "auto-push-old-commits" ''
    set -euo pipefail
    repo="$HOME/.config/home-manager"

    head_ref=$(git -C "$repo" rev-parse --abbrev-ref HEAD)
    # Skip detached HEAD
    [ "$head_ref" = "HEAD" ] && exit 0

    # Only push if the branch already has a remote and merge target set
    remote=$(git -C "$repo" config branch."$head_ref".remote || true)
    merge=$(git -C "$repo" config branch."$head_ref".merge || true)
    if [ -z "$remote" ] || [ -z "$merge" ]; then
      exit 0
    fi

    git -C "$repo" fetch --quiet "$remote"

    if [ "$(git -C "$repo" rev-list --count '@{u}..HEAD')" -eq 0 ]; then
      exit 0
    fi

    oldest=$(git -C "$repo" log --reverse --format=%at '@{u}..HEAD' | head -n 1)
    now=$(date +%s)
    age=$(( (now - oldest) / 86400 ))
    if [ "$age" -ge 2 ]; then
      git -C "$repo" push "$remote" "$head_ref:''${merge#refs/heads/}"
    fi
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

  systemd.user.services.autoPushOldCommits = {
    Unit = {
      Description = "Auto-push home-manager commits older than 2 days";
    };
    Service = {
      Type = "oneshot";
      WorkingDirectory = "/home/southclementide/.config/home-manager";
      ExecStart = "${autoPushOldCommits}";
    };
  };

  systemd.user.timers.autoPushOldCommits = {
    Unit = {
      Description = "Run autoPushOldCommits daily";
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
        export K9S_SKIN="gruvbox-material-light-soft"
        echo "light" > ~/.config/tmux/theme

        glow_config="$HOME/.config/glow/glow.yml"
        ${pkgs.yq-go}/bin/yq -i '.style = "light"' "$glow_config"

        ${pkgs.libnotify}/bin/notify-send "KDE Theme" "Switched to Breeze Light 🌞"
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
        export K9S_SKIN="gruvbox-material-dark-soft"
        echo "dark" > ~/.config/tmux/theme

        glow_config="$HOME/.config/glow/glow.yml"
        ${pkgs.yq-go}/bin/yq -i '.style = "dark"' "$glow_config"

        ${pkgs.libnotify}/bin/notify-send "KDE Theme" "Switched to Breeze Dark 🌙"
      '';
    };
  };
}
