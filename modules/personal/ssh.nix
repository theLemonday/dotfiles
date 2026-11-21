{ lib, ... }:
{
  home.sessionVariables = {
    SSH_ASKPASS = "/usr/bin/ksshaskpass";
    # Force SSH to use the GUI prompt even if you are in a terminal
    SSH_ASKPASS_REQUIRE = "prefer";
  };

  # services.ssh-agent's zsh snippet always runs
  #   export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent"
  # on local shells. A shell started without XDG_RUNTIME_DIR (e.g. the detached
  # tmux server) then gets SSH_AUTH_SOCK=/ssh-agent, misses the agent, and every
  # background `git fetch` (lazygit) pops an askpass prompt. Ensure it is set first.
  programs.zsh.envExtra = lib.mkBefore ''
    export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
  '';
}
