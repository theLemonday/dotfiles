{ pkgs, ... }:
let
  zkNotebookDir = "$HOME/notes";
in
{
  home.sessionVariables = {
    ZK_NOTEBOOK_DIR = zkNotebookDir;
  };

  home.packages = with pkgs; [
    markdownlint-cli

    yaml-language-server
    yamllint
    yamlfix

    # Nix
    nixpkgs-fmt
    nil # nix language server

    # Caddy reverse proxy
    caddy
  ];

  programs.zk = {
    enable = true;
    settings = {
      notebook = {
        dir = zkNotebookDir;
      };
      alias = {
        daily = "zk new --no-input ${zkNotebookDir}/journal/daily";
      };
      extra = {
        author = "Luong Nhat Hao";
      };
      tool = {
        editor = "vi";
      };
      group = {
        daily = {
          paths = [ "journal/daily" ];
          note = {
            filename = "{{format-date now '%Y-%m-%d'}}";
            extension = "md";
            template = "daily.md";
          };
        };
        lab = {
          paths = [ "lab" ];
          note = {
            template = "lab.md";
            extension = "md";
          };
        };
      };
    };
  };
}
