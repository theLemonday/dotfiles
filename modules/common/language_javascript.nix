{ pkgs, ... }:
{
  home.sessionVariables = {
    PNPM_HOME = "$HOME/.pnpm-global";
    PRETTIERD_DEFAULT_CONFIG = "$HOME/.config/prettierd/.prettierrc";
  };

  home.sessionPath = [
    "$HOME/.pnpm-global"
  ];

  home.packages = with pkgs; [
    prettierd
  ];


  home.file = {
    ".config/prettierd/.prettierrc".text = ''
      {
        "printWidth": 80,
        "proseWrap": "always"
      }
    '';
  };
}
