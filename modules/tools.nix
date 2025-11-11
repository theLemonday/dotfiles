{ pkgs, ... }:
let
  trash-cli = pkgs.trash-cli;
  yaziFlavorsSrc = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "flavors";
    rev = "main"; # or a specific commit
    sha256 = "sha256-bavHcmeGZ49nNeM+0DSdKvxZDPVm3e6eaNmfmwfCid0="; # replace after first build
  };
in
{
  home.packages = with pkgs; [
    cloc
    bind
    trash-cli
    silicon
    taskwarrior-tui
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

  home.file.".config/yazi/flavors" = {
    source = yaziFlavorsSrc;
    recursive = true;
  };
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;

    theme =
      {
        light = "kanagawa-lotus";
        dark = "gruvbox-dark";
      };

    # settings = {
    #   manager = {
    #     show_hidden = true;
    #   };
    # };

    shellWrapperName = "y";
  };

  programs.yt-dlp = {
    enable = true;
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

  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;
  };

  programs.ripgrep = {
    enable = true;
  };

  programs.ripgrep-all = {
    enable = true;
  };
}
