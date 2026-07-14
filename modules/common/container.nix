{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dockerfmt
    kind
    dockerfile-language-server
    dive
    hadolint
    podman-compose
    oras
  ];

  home.sessionVariables = {
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
  };

  systemd.user.sockets.podman = {
    Unit = {
      Description = "Podman API Socket";
    };
    Socket = {
      ListenStream = "%t/podman/podman.sock";
      SocketMode = "0660";
    };
    Install = {
      WantedBy = [ "sockets.target" ];
    };
  };
}
