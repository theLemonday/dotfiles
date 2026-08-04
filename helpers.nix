{ pkgs, lib }:
{
  mkPodmanWrapper = { name, image, tag ? "latest", volumes ? [ ], extraArgs ? [ ] }:
    let
      volumeArgs = lib.concatMapStringsSep " " (v: "-v ${v}") volumes;
      customArgs = lib.concatStringsSep " " extraArgs;
    in
    pkgs.writeShellScriptBin name ''
      exec podman run --rm -i \
      ${volumeArgs} \
      ${customArgs} \
      ${image}:${tag} "$@"
    '';
}
