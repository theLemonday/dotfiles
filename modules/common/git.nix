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
      # 1. Base Theme
      syntax-theme = "base16";

      # 2. The Clean Diff (Your preference)
      minus-style = "syntax";
      plus-style = "syntax";
      minus-emph-style = "syntax bold";
      plus-emph-style = "syntax bold";

      # 3. Restoring "Other Components" (The Pop)
      # We use explicit colors (blue, yellow) but AVOID background colors.
      
      # FILE PATHS: Make them Blue and Underlined
      file-style = "blue bold";
      file-decoration-style = "blue ul";

      # COMMIT HASHES: Make them Yellow
      commit-style = "raw"; # 'raw' keeps the original git color, or use "yellow bold"
      commit-decoration-style = "yellow box"; # Adds a yellow box around the commit hash

      # HUNK HEADERS: Make them distinct but transparent
      # "syntax" uses code color, "bold" makes it pop.
      # "box" draws a line around it.
      hunk-header-style = "file line-number syntax bold"; 
      hunk-header-decoration-style = "magenta box"; 

      # 4. Line Numbers (Colorful)
      line-numbers = true;
      line-numbers-zero-style = "cyan";      # Cyan for unchanged lines
      line-numbers-minus-style = "red";      # Red for deleted lines
      line-numbers-plus-style = "green";     # Green for added lines
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        # CRITICAL FIX: 
        # You used 'pagers = [...]' in your snippet. 
        # That is for external commands only. 
        # For the MAIN view, you MUST use 'paging' (singular, table).
        pagers = [{
          colorArg = "always";
          pager = "delta --paging=never";
        }];
      };
      
      gui = {
        theme = {
          activeBorderColor = ["green" "bold"];
          inactiveBorderColor = ["default"];
          # Keeping this "reverse" ensures the cursor is always visible
          selectedLineBgColor = ["reverse"]; 
          selectedRangeBgColor = ["reverse"];
        };
      };
    };
  };
#   programs.delta = {
#   enable = true;
#   enableGitIntegration = true;
#   options = {
#     # 1. Use the terminal's 16 colors
#     syntax-theme = "base16";
#
#     # 2. Styles
#     # We remove 'auto' entirely. 
#     # 'syntax' implies "Use the code's syntax color for the text".
#     # By omitting the background color, it defaults to transparent.
#     minus-style = "syntax";
#     plus-style = "syntax";
#
#     # 3. Emphasis (The Fix)
#     # "syntax bold" is the safest universal style.
#     # It adds weight without adding a clashing background color.
#     minus-emph-style = "syntax bold";
#     plus-emph-style = "syntax bold";
#
#     # 4. Headers
#     hunk-header-style = "file line-number syntax";
#     hunk-header-decoration-style = "none";
#
#     # 5. Line Numbers
#     line-numbers = true;
#     line-numbers-zero-style = "blue";      # Use a base16 color (0-15)
#     line-numbers-minus-style = "red";      # Use a base16 color
#     line-numbers-plus-style = "green";     # Use a base16 color
#   };
# };
#
#   programs.lazygit = {
#     enable = true;
#     settings = {
#       git = {
#         # CRITICAL FIX: Use 'paging', not 'pagers'
#         pagers = [
#           {
#             colorArg = "always";
#             pager = "delta --paging=never";
#           }
#         ];
#       };
#
#       gui = {
#         # 5. UI Theme Transparency
#         # "default" = Transparent (uses terminal background)
#         # "reverse" = Inverts colors (White text on Black bg -> Black text on White bg)
#         # This guarantees the cursor is visible in BOTH modes.
#         theme = {
#           activeBorderColor = ["green" "bold"];
#           inactiveBorderColor = ["default"];
#           selectedLineBgColor = ["reverse"]; 
#           selectedRangeBgColor = ["reverse"];
#         };
#       };
#     };
#   };
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
