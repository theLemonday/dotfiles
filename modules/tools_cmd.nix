{ pkgs, ... }:
let
  trash-cli = pkgs.trash-cli;
in
{
  home.packages = [
    pkgs.ripgrep
    pkgs.bind
    trash-cli
  ];

  home.shellAliases = {
    tput = "trash-put";
    tlist = "trash-list";
    tempty = "trash-empty";
    rm = ''echo " This is not the command you are looking for."; false'';
  };

  systemd.user.services.trashCleanup = {
    Unit = {
      Description = "Empty trash older than 60 days";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${trash-cli}/bin/trash-empty 60";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.timers.trashCleanup = {
    Unit = {
      Description = "Run trashCleanup daily";
    };
    Timer = {
      OnCalendar = "daily";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

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
    defaultCommand = "fd --type f --exclude .git --ignore-file ~/.gitignore";
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
    };
  };
  home.shellAliases = {
    cat = "bat --paging=never";
  };

  programs.cmus = {
    enable = true;
  };

  programs.htop = {
    enable = true;
  };
}
