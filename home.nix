{ pkgs, lib, inputs, ... }:
let
  directories = [
    "$HOME/.pnpm-global"
    "$HOME/.config/zk"
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
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    pkgs.ani-cli

    # Rust programming language packages
    pkgs.cargo
    pkgs.rustc

    pkgs.tealdeer

    pkgs.lazydocker
    pkgs.gnumake
    pkgs.nodejs
    pkgs.gcc
    pkgs.nodejs.pkgs.pnpm
    pkgs.unzip

    pkgs.shfmt
    pkgs.jq

    pkgs.libgen-cli
    pkgs.luajitPackages.luarocks

    pkgs.ansible

    # database

    pkgs.delve
    pkgs.just
    pkgs.imagemagick

    pkgs.awscli2
    pkgs.opentofu
    pkgs.ffmpeg_7-full

    pkgs.zellij

    pkgs.pulumi
    pkgs.pulumiPackages.pulumi-language-go

    pkgs.prettierd
    pkgs.templ

    pkgs.lua5_1

    pkgs.hey

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.activation.createDirs = lib.mkAfter ''
    # Use builtins.map to create directories
    ${lib.concatStringsSep "\n" (builtins.map (dir: ''
      mkdir -p ${dir}
    '') directories)}
  '';

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
  #  /etc/profiles/per-user/lemonday/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    PNPM_HOME = "$HOME/.pnpm-global";
    VAGRANT_WSL_ENABLE_WINDOWS_ACCESS = "1";
    EDITOR = "nvim";
    FLYCTL_INSTALL = "/home/lemonday/.fly";
    ZK_NOTEBOOK_DIR = "$HOME/notes";
    LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${pkgs.glib.out}/lib:${pkgs.stdenv.cc.cc.lib}/lib";
  };

  home.sessionPath = [
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "$HOME/.pnpm-global"
    "$HOME/.local/share/nvim/mason/bin"
    "$FLYCTL_INSTALL/bin"
  ];

  home.shellAliases = {
    ls = "eza";
    ll = "ls -l";

    update = "sudo nixos-rebuild switch";
    lzd = "lazydocker";
    lzg = "lazygit";
    n = "nvim";
    nf = "nvim $(fzf)";
    pnpx = "pnpm dlx";
    hm = "home-manager";
    hms = "home-manager switch";
    tf = "terraform";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.ssh-agent.enable = true;

  programs.bun = {
    enable = true;
    enableGitIntegration = true;
  };
}
