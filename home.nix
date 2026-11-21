{ config
, pkgs
, lib
, ...
}:
let
  directories = [
    ".config/zsh/conf.d"
  ];
in
{
  home.stateVersion = "25.05"; # Please read the comment before changing.

  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ./secrets/secrets.yml;
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    sops
    gnumake
    unzip
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
    SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    # enable the podman socket first systemctl enable --now podman.socket
    CLAB_RUNTIME = "podman";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.config/home-manager/scripts"
  ];

  home.shellAliases = {
    ls = "eza";
    k = "kubectl";
    lzg = "lazygit";
    gitroot = "cd $(git rev-parse - -show-toplevel)";
    # docker = "nerdctl";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "${config.xdg.configHome}/home-manager/";
  };

  # Determinate Nix installs `nix` in the default profile, which is not on the
  # systemd user PATH, so the nh-clean timer failed with "No output from nix --version".
  systemd.user.services.nh-clean.Service.Environment = [
    "PATH=/nix/var/nix/profiles/default/bin:/usr/bin:/bin"
  ];

  services.ssh-agent = {
    enable = true;
  };
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [
      "config.d/*"
      # config.sops.secrets."ssh".path
    ];
    settings = {
      "github.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/id_github";
        identitiesOnly = true;
        addKeysToAgent = "yes";
      };
    };
  };
}