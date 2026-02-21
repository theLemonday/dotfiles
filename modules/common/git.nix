{ pkgs, ... }: {
  home.packages = with pkgs;[
    glab
  ];
  programs.git = {
    enable = true;
    settings = {
      pull.rebase = true;
      alias = {
        co = "checkout";
        br = "branch";
        cm = "commit -m";
        st = "status";
        wtl = "worktree list";
        wtc = "worktree add -b";
        wtr = "worktree remove";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
      delta = prev.delta.overrideAttrs (oldAttrs: {
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ prev.installShellFiles ];

        postInstall = (oldAttrs.postInstall or "") + ''
          installShellCompletion --cmd delta \
            --zsh <($out/bin/delta --generate-completion zsh)
        '';
      });
    })
  ];
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      syntax-theme = "base16";
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        pagers = [{
          colorArg = "always";
          pager = "delta --paging=never";
        }];
      };

      gui = {
        theme = {
          selectedLineBgColor = [ "reverse" ];
          selectedRangeBgColor = [ "reverse" ];
        };
      };
    };
  };
}
