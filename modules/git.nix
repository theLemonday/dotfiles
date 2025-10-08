{ ... }: {
  programs.git = {
    enable = true;
    userName = "theLemonday";
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

    aliases = {
      co = "checkout";
      br = "branch";
      cm = "commit -m";
      st = "status";
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
