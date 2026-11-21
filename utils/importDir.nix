# Returns the list of every sibling .nix file in `dir` (except default.nix),
# for use as `imports`. Drop a file in the directory and it is picked up.
{ lib, dir }:
lib.pipe (builtins.readDir dir) [
  (lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"))
  builtins.attrNames
  (map (name: dir + "/${name}"))
]
