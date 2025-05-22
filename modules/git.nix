{ ... }: {
  programs.git = {
    enable = true;
    userName = "Lemonday";
    userEmail = "nhathao090703@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
    };

    # core = {
    #   pager = "delta";
    #   interactive = "delta --color-only";
    #   delta = {
    #     navigate = true;
    #   };
    #   merge = {
    #     conflictstyle = "diff3";
    #   };
    #   diff = {
    #     colorMoved = "default";
    #   };
    # };

    delta = {
      enable = true;
    };
  };

  programs.lazygit = {
    enable = true;

    settings = {
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };
    };
  };

}
