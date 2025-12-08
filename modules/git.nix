{ pkgs, ... }: {
  home.packages = with pkgs;[
    husky
    lint-staged
    commitlint
  ];

  programs.git = {
    enable = true;
    settings = {
      pull.rebase = true;
      user =
        {
          name = "theLemonday";
          email = "nhathao090703@gmail.com";
        };
      alias = {
        co = "checkout";
        br = "branch";
        cm = "commit -m";
        st = "status";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.delta = { enable = true; enableGitIntegration = true; };

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
