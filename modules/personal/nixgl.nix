{ inputs, pkgs, ... }:
{
  home.packages = [ inputs.ngosen.packages.${pkgs.stdenv.hostPlatform.system}.default ];

  targets.genericLinux.nixGL = {
    packages = inputs.nixgl.packages;
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
    vulkan.enable = true;
  };
}
