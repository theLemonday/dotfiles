{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wgo
    dust
    trash-cli
    bpftrace
    go-task
    bazelisk
    bazel-buildtools
    miller
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

  programs.navi = {
    enable = true;
    enableZshIntegration = true; # Binds Ctrl+G in Zsh to open navi
  };
  home.file.".local/share/navi/cheats/lab.cheat".text = ''
    % lab, python, uv

    # Scaffold a new Python lab note via zk and initialize with uv
    bash -ec '
        TITLE="<title>"
        FILE_PATH=$(zk new --title "$TITLE" --print-path lab)
        if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
            echo "Error: zk failed to create note" >&2
            exit 1
        fi

        DIR_PATH=$(dirname "$FILE_PATH")
        echo "Creating uv project in: $DIR_PATH"
        uv init --no-readme --vcs none "$DIR_PATH"

        cat > "$DIR_PATH/.gitignore" <<EOF
    .venv/
    __pycache__/
    *.pyc
    .env
    .python-version
    EOF

        echo "Successfully created lab at: $DIR_PATH"
    '

    % lab, rust, cargo

    # Scaffold a new Rust lab note via zk and initialize with cargo
    bash -ec '
        TITLE="<title>"
        FILE_PATH=$(zk new lab --title "$TITLE" --print-path)
        if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
            echo "Error: zk failed to create note" >&2
            exit 1
        fi

        DIR_PATH=$(dirname "$FILE_PATH")
        PKG_NAME=$(basename "$DIR_PATH")

        echo "Initializing Cargo package ($PKG_NAME) in: $DIR_PATH"
        cargo init --name "$PKG_NAME" --vcs none "$DIR_PATH"

        cat > "$DIR_PATH/.gitignore" <<EOF
    /target
    Cargo.lock
    .env
    EOF

        echo "Successfully created Rust lab at: $DIR_PATH"
    '
  '';

  home.file.".local/share/navi/cheats/system.cheat".text = ''
    % system, fonts

    # Install fonts (.ttf, .otf, .woff, .woff2) and regenerate font cache
    FONT_DEST="<font_dest>" && \
    mkdir -p "$FONT_DEST" && \
    find "<src_dir>" -type f \( \
        -iname '*.ttf' -o \
        -iname '*.otf' -o \
        -iname '*.woff' -o \
        -iname '*.woff2' \
    \) -exec cp -v {} "$FONT_DEST" \; && \
    fc-cache -f "$FONT_DEST" && \
    echo "Fonts installed into: $FONT_DEST"

    $ font_dest: echo "$HOME/.local/share/fonts\n$HOME/.fonts"
    $ src_dir: find . -maxdepth 3 -type d 2>/dev/null

    % browser, cleanup

    # Remove Brave browser singleton lock
    rm -rf ~/.config/BraveSoftware/Brave-Browser/SingletonLock && \
    echo "Removed Brave SingletonLock"

    % git

    # Generate a .gitignore template using gibo
    gibo dump <language_or_framework> >> .gitignore

    $ language_or_framework: gibo list | tr ' ' '\n'
  '';

  home.file.".local/share/navi/cheats/nix.cheat".text = ''
    % nix, home-manager

    # Commit home-manager changes and switch profile via nh
    bash -ec '
        HOME_MANAGER_DIR="$HOME/.config/home-manager"
        PROFILE="<profile>"

        if [ ! -d "$HOME_MANAGER_DIR/.git" ]; then
            echo "❌ Not a git repo: $HOME_MANAGER_DIR" >&2
            exit 1
        fi

        if ! command -v nh >/dev/null 2>&1; then
            echo "❌ \"nh\" CLI not found on PATH" >&2
            exit 1
        fi

        cd "$HOME_MANAGER_DIR"

        if [ -z "$(git status --porcelain)" ]; then
            HAS_CHANGES=0
            echo "✨ No changes to commit."
        else
            HAS_CHANGES=1
            echo "▣ Committing tracked and untracked changes..."
            git commit -am "Updated $(date)"
        fi

        echo "⚙️ Running nh home switch for profile: $PROFILE..."
        if nh home switch "$HOME_MANAGER_DIR" --configuration "$PROFILE"; then
            echo "✅ Switch succeeded."
            [ "$HAS_CHANGES" -eq 1 ] && echo "   Kept commit."
        else
            echo "❌ Switch failed." >&2
            if [ "$HAS_CHANGES" -eq 1 ]; then
                echo "   Reverting git commit..." >&2
                git reset --soft HEAD~1
            fi
            exit 1
        fi
    '

    $ profile: printf "%s\n" personal work
  '';
}
