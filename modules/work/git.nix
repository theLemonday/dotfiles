{ config, ... }:
{
  programs.git = {
    includes = [ { path = config.sops.secrets."work_git_config".path; } ];
  };
}
