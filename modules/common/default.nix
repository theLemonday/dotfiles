{ lib, ... }:

{
  imports =
    let
      # Read all files in the current directory
      files = builtins.readDir ./.;

      # Filter: Keep only .nix files, but ignore default.nix (to avoid infinite loop)
      nixFiles = lib.filterAttrs
        (name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix")
        files;

      # Convert filenames to absolute paths for import
      importPaths = map (name: ./. + "/${name}") (builtins.attrNames nixFiles);
    in
    importPaths;
}
