{ pkgs, ... }:
{
  home.packages = with pkgs; [
    terraform-ls
  ];

}
