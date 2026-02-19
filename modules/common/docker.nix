{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dockerfmt
    kind
    dockerfile-language-server
    dive
    hadolint
    nerdctl
  ];
  nixpkgs.overlays = [
    (final: prev: {
      nerdctl = prev.ko.overrideAttrs (oldAttrs: {
        # 1. Add the utility that provides 'installShellCompletion'
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ final.installShellFiles ];

        # 2. Run the command after the main install phase
        postInstall = (oldAttrs.postInstall or "") + ''
          # The command you suggested:
          installShellCompletion --cmd nerdctl \
            --zsh <($out/bin/nerdctl completion zsh) 
        '';
      });
    })
  ];

}
