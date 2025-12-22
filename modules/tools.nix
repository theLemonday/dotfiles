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
    wgo
    dust
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
    enableZshIntegration = true;

    settings = {
      plugin =
        {
          prepend_previewers = [
            {
              name = "*.md";
              run = "piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dracula \"$1\"";
            }
            {
              url = "*/";
              run = "piper -- eza -TL=3 --group-directories-first --no-quotes \"$1\"";
            }
          ];
        };
    };

    keymap = {
      mgr = {
        prepend_keymap = [
          {
            on = [ "g" "n" ];
            run = "cd ~/.config/home-manager";
            desc = "[G]o [N]ix home manager";
          }
        ];
      };
    };

    shellWrapperName = "y";

    plugins = with pkgs.yaziPlugins;{
      piper = piper;
      git = git;
    };

  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;

    tmux = {
      enableShellIntegration = true;
    };
    defaultCommand = "fd --type f --exclude .git --ignore-file ~/.gitignore --color=never";
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    icons = "auto";
    colors = "always";
  };

  programs.fd = {
    enable = true;
  };

  home.sessionVariables = {
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
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
    arguments = [ "--smart-case" ];
  };

  programs.ripgrep-all = {
    enable = true;
  };

  programs.tealdeer = {
    enable = true;
    settings = {
      updates = { auto_update = true; };
    };
  };
}





