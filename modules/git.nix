{ pkgs, ... }: {
  home.packages = with pkgs;[
    husky
    lint-staged
    commitlint
  ];

  programs.git = {
    enable = true;
    userName = "theLemonday";
    userEmail = "nhathao090703@gmail.com";

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
