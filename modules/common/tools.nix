{ pkgs, ... }:
let
  # 1. Foundation: Creates note and prints target directory
  zkNewLab = pkgs.writeShellApplication {
    name = "zk-new-lab";
    runtimeInputs = with pkgs; [ coreutils zk ];
    text = ''
      TITLE="$1"
      FILE_PATH=$(zk new lab --title "$TITLE" --print-path)

      if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
        echo "Error: zk failed to create note" >&2
        exit 1
      fi

      dirname "$FILE_PATH"
    '';
  };

  # 2. Python Specialist
  initPython = pkgs.writeShellApplication {
    name = "zk-init-python";
    runtimeInputs = with pkgs; [ coreutils gibo ];
    text = ''
      DIR="$1"
      echo "Creating uv project in: $DIR"
      uv init --no-readme --vcs none "$DIR"
      gibo dump Python > "$DIR/.gitignore"
      printf "\n# Lab overrides\n.env\n" >> "$DIR/.gitignore"
      echo "Successfully created Python lab at: $DIR"
    '';
  };

  # 3. Rust Specialist
  initRust = pkgs.writeShellApplication {
    name = "zk-init-rust";
    runtimeInputs = with pkgs; [ coreutils gibo ];
    text = ''
      DIR="$1"
      PKG=$(basename "$DIR")
      echo "Initializing Cargo package ($PKG) in: $DIR"
      cargo init --name "$PKG" --vcs none "$DIR"
      gibo dump Rust > "$DIR/.gitignore"
      printf "\n# Lab overrides\n.env\n" >> "$DIR/.gitignore"
      echo "Successfully created Rust lab at: $DIR"
    '';
  };

  # 4. Go Specialist
  initGo = pkgs.writeShellApplication {
    name = "zk-init-go";
    runtimeInputs = with pkgs; [ coreutils gibo ];
    text = ''
            DIR="$1"
            PKG=$(basename "$DIR")
            echo "Initializing Go module ($PKG) in: $DIR"
            (cd "$DIR" && go mod init "$PKG")
            cat > "$DIR/main.go" <<EOF
      package main

      import "fmt"

      func main() {
      	fmt.Println("Hello from $PKG")
      }
      EOF
            gibo dump Go > "$DIR/.gitignore"
            printf "\n# Lab overrides\n.env\n" >> "$DIR/.gitignore"
            echo "Successfully created Go lab at: $DIR"
    '';
  };
in
{
  home.packages = with pkgs; [
    wgo
    dust
    trash-cli
    bpftrace
    bazelisk
    bazel-buildtools
    miller
    taskwarrior3
    copier
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
      ExecStart = "${pkgs.trash-cli}/bin/trash-empty 60";
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
      plugin = {
        prepend_previewers = [
          {
            name = "*.md";
            run = "piper -- CLICOLOR_FORCE=1 glow -w=$w \"$1\"";
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
            on = [
              "g"
              "n"
            ];
            run = "cd ~/.config/home-manager";
            desc = "[G]o [N]ix home manager";
          }
        ];
      };
    };

    shellWrapperName = "y";

    plugins = with pkgs.yaziPlugins; {
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
    defaultOptions = [ "--height 40%" "--border" "--layout=reverse" ];
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
    MANROFFOPT = "-c";
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

  programs.tealdeer = {
    enable = true;
    settings = {
      updates = {
        auto_update = true;
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # caches devShell derivation; without this,
    # `use flake` re-evaluates on every cd — slow
    enableZshIntegration = true; # injects `eval "$(direnv hook zsh)"` for you
  };
}
