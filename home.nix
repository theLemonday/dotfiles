{ config, pkgs, lib, ... }:
let
  zkNotebookDir = "notes";

  directories = [
    ".pnpm-global"
    ".config/zk"
    ".config/mpd"
    ".custom-script"
    zkNotebookDir
  ];
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "lemonday";
  home.homeDirectory = "/home/lemonday";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs;[
    # Graphics
    nixgl.nixGLIntel

    nix-output-monitor
    wl-clipboard-rs
    # pkgs.nix-your-shell

    x11_ssh_askpass
    glibc
    nix-ld
    cmake

    ani-cli

    tealdeer

    lazydocker
    gnumake
    gcc
    unzip

    libgen-cli
    luajitPackages.luarocks

    just
    imagemagick

    awscli2
    ffmpeg_7-full

    # fonts
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    (google-fonts.override {
      fonts = [ "GrapeNuts" "IcomoonFeather" ];
    })

    hey

    openstackclient

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # (pkgs.writeShellScriptBin "hms")
  ];

  home.activation = {
    init = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${lib.concatStringsSep "\n" (builtins.map (dir: ''
        mkdir -p ~/${dir}
      '') directories)}
    '';
  };
  # home.activation.createDirs = lib.mkAfter ''
  #   # Use builtins.map to create directories
  #   ${lib.concatStringsSep "\n" (builtins.map (dir: ''
  #     mkdir -p /home/${config.home.username}/${dir}
  #   '') directories)}
  # '';

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
    ".custom-script/xdg-open".source = ./scripts/xdg-open;
    ".markdownlint.json".source = ./dotfiles/markdownlint.json;
    ".config/kitty/dark-theme.auto.conf".source = ./dotfiles/kitty/dark-theme.auto.conf;
    ".config/kitty/light-theme.auto.conf".source = ./dotfiles/kitty/light-theme.auto.conf;
    ".config/kitty/no-preference-theme.auto.conf".source = ./dotfiles/kitty/no-preference-theme.auto.conf;
    # ".config/kitty/kitty.conf".source = config.lib.file.mkOutOfStoreSymlink /home/lemonday/.config/home-manager/dotfiles/kitty.conf;
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
    VAGRANT_WSL_ENABLE_WINDOWS_ACCESS = "1";
    EDITOR = "nvim";
    FLYCTL_INSTALL = "/home/lemonday/.fly";
    ZK_NOTEBOOK_DIR = zkNotebookDir;
  };

  home.sessionPath = [
    # "$HOME/.local/share/nvim/mason/bin"
    "$FLYCTL_INSTALL/bin"
    "$HOME/.custom-script"
  ];

  home.shellAliases = {
    kitty = "nixGLIntel kitty";
    ls = "eza";
    ll = "ls-l";
    k = "kubectl";
    update = "sudo nixos-rebuild switch";
    lzd = "lazydocker";
    lzg = "lazygit";
    n = "nvim";
    nf = "nvim $(fzf)";
    pnpx = "pnpm dlx";
    hm = "home-manager";
    hms = "$HOME/.config/home-manager/update-home.fish";
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

  xdg.userDirs = {
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
}
