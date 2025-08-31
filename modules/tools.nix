{ pkgs, ... }:
let
  themeRepo = pkgs.fetchFromGitHub {
    owner = "adi1090x";
    repo = "rofi";
    rev = "master";
    hash = "sha256-yMKpwxdwvp7ryz2XXunbjC/5ud9HHEDzyYRhM540958=";
  };

  trash-cli = pkgs.trash-cli;
in
{
  home.packages = with pkgs; [
    cloc
    bind
    trash-cli
    silicon
    vit
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
      italic-text = "always";
      pager = "less -FR";
      theme = "base16-256";
    };
  };
  home.shellAliases.cat = "bat --paging=never";

  programs.bottom.enable = true;

  # programs.rofi = {
  #   enable = true;
  # };
  #
  # home.file.".config/rofi/" = {
  #   source = "${themeRepo}/files";
  #   recursive = true;
  # };

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
