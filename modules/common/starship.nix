{ pkgs, ... }: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    # Configure the look right here in Nix!
    settings = {
      format = "$directory$git_branch$fill$kubernetes\n$character";
      fill = {
        symbol = " ";
      };

      add_newline = true;

      # 3. Your Custom Git Configuration
      git_branch = {
        symbol = "";
      };

      cmd_duration = { disabled = true; };

      kubernetes = {
        disabled = false;
        format = "[$symbol$context(\($namespace\))]($style)";
      };

      python = {
        detect_files = [ "requirements.txt" "pyproject.toml" ".python-version" ];
        detect_folders = [ ".venv" "venv" ];
        format = "via [\${symbol}\${pyenv_prefix}(\${version} )(\\($virtualenv\\))]($style) ";
      };
    };
  };
}
