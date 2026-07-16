{ pkgs, config, ... }:
let
  zkNotebookDir = "$HOME/Documents/notes";
in
{
  home.sessionVariables = {
    ZK_NOTEBOOK_DIR = zkNotebookDir;
  };

  home.packages = with pkgs; [
    markdownlint-cli


    (config.lib.nixGL.wrap obsidian)
    qt6.qttools
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
        author = "Southclementide";
      };
      note = {
        language = "en";
        default-title = "Untitled";

        # This names the physical file. 
        # {{id}} is a unique fingerprint, and {{slug title}} makes the title safe for URLs and paths.
        filename = "{{id}}-{{slug title}}";
        extension = "md";

        # The markdown file template used when you create a new note
        template = "default.md";

        # We use a 4-character lowercase alphanumeric ID for clean, short filenames
        id-charset = "alphanum";
        id-length = 4;
        id-case = "lower";
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
            # This creates a folder named after the lab, and places a file named 'README.md' inside it.
            filename = "{{slug title}}/README";
          };
        };
      };
    };
  };
}
