{ config, ... }:
{
  sops.secrets."work_git_config".sopsFile = ../../secrets/work_git_config.yml;

  programs.git.includes = [ { path = config.sops.secrets."work_git_config".path; } ];
}
