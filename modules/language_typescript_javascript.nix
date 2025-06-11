{ pkgs, ... }: {
  home.packages = with pkgs; [
    typescript
    typescript-language-server
  ];
}
