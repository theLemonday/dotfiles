{ lib, ... }:
{
  imports = import ../../utils/importDir.nix { inherit lib; dir = ./.; };
}
