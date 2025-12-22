{ pkgs, ... }: {
  home.packages = with pkgs;[
    husky
    lint-staged
    commitlint
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "theLemonday";
        email = "nhathao090703@gmail.com";
      };
      pull.rebase = true;
      # rebase.autoStash = true;
      # # Optional: helps with those repetitive conflicts we talked about
      # rerere.enabled = true;
    };

    extraConfig = {
      init.defaultBranch = "main";
    };

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
        pagers = [
          {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          }
        ];
      };
    };
  };
}
