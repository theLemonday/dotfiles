{ config, pkgs, lib, ... }:
let
  directories = [
    ".pnpm-global"
    ".config/mpd"
    ".custom-script"
  ];

  user = "lemonday";
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = user;
  home.homeDirectory = "/home/${user}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs;[
    wl-clipboard-rs

    # glibc
    # nix-ld
    cmake

    ani-cli

    tealdeer

    gnumake
    gcc
    unzip

    luajitPackages.luarocks

    just
    imagemagick

    ffmpeg_7-full

    # fonts
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    (google-fonts.override {
      fonts = [ "GrapeNuts" "IcomoonFeather" ];
    })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.activation = {
    init = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${lib.concatStringsSep "\n" (builtins.map (dir: ''
        mkdir -p ~/${dir}
      '') directories)}
    '';
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".markdownlint.json".source = ./dotfiles/markdownlint.json;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/lemonday/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vi";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.custom-script"
    "${config.home.homeDirectory}/.config/emacs/bin"
  ];

  home.shellAliases = {
    ls = "eza";
    ll = "ls -l";
    k = "kubectl";
    lzd = "lazydocker";
    lzg = "lazygit";
    n = "nvim";
    nf = "nvim $(fzf)";
    pnpx = "pnpm dlx";
    hm = "nh home";
    hms = "/home/${user}/.config/home-manager/scripts/update-home.fish";
    tf = "terraform";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.ssh-agent.enable = true;

  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };

  fonts.fontconfig.enable = true;

  xdg = {
    userDirs = {
      enable = true;

      desktop = "${config.home.homeDirectory}/Desktop";
      download = "${config.home.homeDirectory}/Downloads";
      templates = "${config.home.homeDirectory}/Templates";
      publicShare = "${config.home.homeDirectory}/Public";
      documents = "${config.home.homeDirectory}/Documents";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/lemonday/.config/home-manager/";
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
        if [[ "$XDG_CURRENT_DESKTOP" == "KDE" ]]; then
          lookandfeeltool -a org.kde.breeze.desktop
          plasma-apply-colorscheme BreezeLight
        fi
      '';
    };
    darkModeScripts = {
      set-theme = ''
        if [[ "$XDG_CURRENT_DESKTOP" == "KDE" ]]; then
          lookandfeeltool -a org.kde.breezedark.desktop
          plasma-apply-colorscheme BreezeDark
        fi
      '';
    };
  };

  programs.anki = {
    enable = true;
    sync = {
      # usernameFile = builtins.readFile ./secrets/ankiUsername;
      # passwordFile = builtins.readFile ./secrets/ankiPassword;
    };
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };
}
