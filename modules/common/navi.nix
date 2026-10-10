{ pkgs, config, ... }:
{
  programs.navi = {
    enable = true;
    enableZshIntegration = true; # Binds Ctrl+G in Zsh to open navi
    settings.cheats.paths = [
      "${config.xdg.dataHome}/navi/cheats"
      "${config.home.homeDirectory}/Documents/cheats"
    ];
  };

  # $ profile: printf "%s\n" personal work
  # When you trigger the command, navi opens an fzf prompt showing:
  # > personal
  # work
  home.file.".local/share/navi/cheats/lab.cheat".text = ''
    % nix, lab, zk

    # Create a new lab from a copier template, drop into its activated devShell
    bash -ec '
        TEMPLATES_DIR="$HOME/Documents/notes/templates"
        TEMPLATE="<template>"
        TITLE="<title>"

        if [ ! -d "$TEMPLATES_DIR/$TEMPLATE" ]; then
            echo "❌ Template not found: $TEMPLATES_DIR/$TEMPLATE" >&2
            exit 1
        fi

        if ! command -v copier >/dev/null 2>&1; then
            echo "❌ \"copier\" CLI not found on PATH" >&2
            exit 1
        fi

        SLUG=$(echo "$TITLE" | tr "[:upper:]" "[:lower:]" | tr " " "-")
        DIR="$HOME/Documents/notes/lab/$SLUG"

        echo "▣ Scaffolding \"$TITLE\" from template: $TEMPLATE..."
        if copier copy --defaults -d project_name="$TITLE" --trust "$TEMPLATES_DIR/$TEMPLATE" "$DIR"; then
            echo "✅ Lab created at: $DIR"
        else
            echo "❌ copier failed." >&2
            exit 1
        fi
    ' && cd "$HOME/Documents/notes/lab/$(echo "<title>" | tr "[:upper:]" "[:lower:]" | tr " " "-")" && direnv allow .

    $ template: fd --max-depth 1 -t d . "$HOME/Documents/notes/templates" --exec basename
  '';

  home.file.".local/share/navi/cheats/system.cheat".text = ''
    % browser, cleanup

    # Remove Brave browser singleton lock
    rm -rf ~/.config/BraveSoftware/Brave-Browser/SingletonLock && \
    echo "Removed Brave SingletonLock"
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
        if nh home switch "$HOME_MANAGER_DIR" --configuration "$PROFILE";
      then
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

