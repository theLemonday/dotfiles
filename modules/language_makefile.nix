{ pkgs, ... }:
let
  mbake-completions = pkgs.runCommand "mbake-completions" { } ''
    # Create the standard Zsh completion directory structure
    mkdir -p $out/share/zsh/site-functions
    
    # Generate the completion file
    # Note: We name it '_mbake' which is the standard Zsh convention
    ${pkgs.mbake}/bin/mbake completions zsh > $out/share/zsh/site-functions/_mbake
  '';
in
{
  home.packages = with pkgs; [
    mbake
    mbake-completions
  ];
}
