{ pkgs, ... }:
let
  trash-cli = pkgs.trash-cli;
in
{
  home.packages = with pkgs; [
    cloc
    bind
    trash-cli
    silicon
    cookiecutter
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

    shellWrapperName = "y";
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;

    tmux = {
      enableShellIntegration = true;
    };
    defaultCommand = "fd --type f --exclude .git --ignore-file ~/.gitignore";
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    icons = "auto";
    colors = "always";
  };

  programs.fd = {
    enable = true;
  };


  home.sessionVariables = {
    MANPAGER = "sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | bat -p -lman'";
  };
  programs.bat = {
    enable = true;
    config = {
      style = "plain";
      italic-text = "always";
      pager = "less -FR";
      theme = "base16-256";
    };
  };
  home.shellAliases.cat = "bat --paging=never";

  programs.bottom.enable = true;

  programs.ripgrep = {
    enable = true;
  };

  programs.ripgrep-all = {
    enable = true;
  };
}
