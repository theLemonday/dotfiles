{ pkgs, ... }:
{
  home.packages = with pkgs; [
    go-tools
    delve
    gopls

    # formatter
    gotools
    golines
    gofumpt
    ko
  ];

  nixpkgs.overlays = [
    (final: prev: {
      ko = prev.ko.overrideAttrs (oldAttrs: {
        # 1. Add the utility that provides 'installShellCompletion'
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ final.installShellFiles ];

        # 2. Run the command after the main install phase
        postInstall = (oldAttrs.postInstall or "") + ''
          # The command you suggested:
          installShellCompletion --cmd ko \
            --zsh <($out/bin/ko completion zsh) 
        '';
      });
    })
  ];
  home.sessionPath = [
    "$HOME/go/bin"
  ];

  programs.go = {
    enable = true;
  };
}
