{ config, pkgs, lib, ... }:
let
  directories = [
    ".pnpm-global"
    ".config/mpd"
    ".custom-script"
  ];

in
{

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  xdg = {
    enable = true;

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

  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ./secrets/default.yaml;
    secrets = {
      "anki/username" = { };
      "anki/password" = { };
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs;
    [
      wl-clipboard-rs

      sops
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
    "${config.home.homeDirectory}/.config/home-manager/scripts"
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
    hms = "${config.xdg.configHome}/home-manager/scripts/update-home.fish";
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

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "${config.xdg.configHome}/home-manager/";
  };

  programs.anki = {
    enable = true;
    sync = {
      # usernameFile = config.age.secrets.anki_username.path;
      username = "nhathao090703@gmail.com";
      # passwordFile = /tmp/test;
      passwordFile = config.sops.secrets."anki/password".path;
    };
    language = "en_US";
    package = config.lib.nixGL.wrap pkgs.anki;
    minimalistMode = true;
    style = "native";
    # videoDriver = "vulkan";
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.ssh = {
    enable = true;
  };
}
