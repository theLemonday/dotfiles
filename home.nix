{
  config,
  pkgs,
  lib,
  ...
}:
let
  directories = [
    ".pnpm-global"
    ".custom-script"
    ".config/zsh/conf.d"
  ];
in
{
  home.stateVersion = "25.05"; # Please read the comment before changing.

  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ./secrets/default.yaml;
    secrets = {
      "ssh" = {
        sopsFile = ./secrets/ssh.yml;
      };
      "work_git_config" = {
        sopsFile = ./secrets/work_git_config.yml;
      };
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    sops
    # cmake

    gnumake
    gcc
    unzip

    luajitPackages.luarocks

    just

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.activation = {
    init = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${lib.concatStringsSep "\n" (
        builtins.map (dir: ''
          mkdir -p ~/${dir}
        '') directories
      )}
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
  #  /etc/profiles/per-user/southclementide/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vi";
    XMODIFIERS = "@im=fcitx";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.config/home-manager/scripts"
  ];

  home.shellAliases = {
    ls = "eza";
    k = "kubectl";
    lzg = "lazygit";
    hms = "${config.xdg.configHome}/home-manager/scripts/update-home.zsh";
    docker = "nerdctl";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "${config.xdg.configHome}/home-manager/";
  };

  services.ssh-agent = {
    enable = true;
  };
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [
      "config.d/*"
      config.sops.secrets."ssh".path
    ];
  };
}
