{ inputs, ... }: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
}
