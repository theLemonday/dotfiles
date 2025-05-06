{ pkgs, ... }: {
  home.packages = with pkgs; [
    texlab

    # pkgs.texlive.latexindent
    # pkgs.texlive.combined.scheme-full
  ];

}
