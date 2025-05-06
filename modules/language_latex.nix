{ pkgs, ... }:
let
  texliveBundle = pkgs.texliveFull.withPackages (ps: [
    ps.latexmk
  ]);
in
{
  home.packages = with pkgs; [
    texlab
    texliveBundle
    # texlivePackages.latexmk
    # pkgs.texlive.latexindent
    # pkgs.texlive.combined.scheme-full
  ];

}
