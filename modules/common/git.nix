{
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
        # This is the MAGIC SWITCH. 
        # It tells Delta: "Use the terminal's 16 colors for syntax highlighting."
        syntax-theme = "base16";
        
        # Now we map the diff styles to strict ANSI colors (0-15).
        # "syntax" = use the syntax highlighting colors
        # "auto" = let Delta pick the background style from the theme
        
        # DELETE (Red): Use terminal color 1 (Red) for text, no distinctive background
        minus-style = "syntax auto";
        
        # ADD (Green): Use terminal color 2 (Green) for text
        plus-style = "syntax auto";
        
        # CLEANUP: Remove the "box" decorations that often clash with themes
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-style = "bold yellow ul";
          file-decoration-style = "none";
        };
      };
  };

  programs.lazygit = {
    enable = true;

    settings = {
      git = {
        pagers = [
          {
            colorArg = "always";
            pager = "delta --paging=never";
          }
        ];
      };
    };
  };
}
