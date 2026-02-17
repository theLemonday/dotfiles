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
      # 1. Use the terminal's colors
      syntax-theme = "base16";

      # 2. THE FIX: Transparency ("syntax auto")
      # This removes the background color from diff lines.
      # It forces Delta to only color the TEXT (syntax), not the background box.
      minus-style = "syntax auto";
      plus-style = "syntax auto";
      
      # Optional: Make the specific character changes bold/reversed
      minus-emph-style = "syntax auto reversed"; 
      plus-emph-style = "syntax auto reversed";

      # 3. Clean up the UI
      # Remove the large "file box" headers which often clash in Light Mode
      hunk-header-style = "file line-number syntax";
      hunk-header-decoration-style = "none";
      
      # 4. Line Numbers
      line-numbers = true;
      line-numbers-zero-style = "auto"; # Grey
      line-numbers-minus-style = "auto"; # Red
      line-numbers-plus-style = "auto"; # Green
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        # CRITICAL FIX: Use 'paging', not 'pagers'
        pagers = [
          {
            colorArg = "always";
            pager = "delta --paging=never";
          }
        ];
      };
      
      gui = {
        # 5. UI Theme Transparency
        # "default" = Transparent (uses terminal background)
        # "reverse" = Inverts colors (White text on Black bg -> Black text on White bg)
        # This guarantees the cursor is visible in BOTH modes.
        theme = {
          activeBorderColor = ["green" "bold"];
          inactiveBorderColor = ["default"];
          selectedLineBgColor = ["reverse"]; 
          selectedRangeBgColor = ["reverse"];
        };
      };
    };
  };
  # programs.delta = {
  #   enable = true;
  #   enableGitIntegration = true;
  #   options = {
  #       # This is the MAGIC SWITCH. 
  #       # It tells Delta: "Use the terminal's 16 colors for syntax highlighting."
  #       syntax-theme = "base16";
  #     };
  # };
  #
  # programs.lazygit = {
  #   enable = true;
  #
  #   settings = {
  #     git = {
  #       pagers = [
  #         {
  #           colorArg = "always";
  #           pager = "delta --paging=never";
  #         }
  #       ];
  #     };
  #   };
  # };
}
