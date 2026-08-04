{ pkgs, lib }:
{
  mkPodmanWrapper = { name, image, tag ? null, volumes ? [ ], extraArgs ? [ ] }:
    let
      volumeArgs = lib.concatMapStringsSep " " (v: "-v ${v}") volumes;
      customArgs = lib.concatStringsSep " " extraArgs;

      # 1. If tag is null, default to "latest". Otherwise, use the provided tag.
      resolvedTag = if tag == null then "latest" else tag;

      # 2. Check if the tag is a digest (starts with "sha256:")
      isDigest = lib.hasPrefix "sha256:" resolvedTag;

      # 3. Use '@' for digests, and ':' for standard tags
      separator = if isDigest then "@" else ":";

      # 4. Assemble the final image string (e.g., docker.io/alpine/helm@sha256:123...)
      fullImage = "${image}${separator}${resolvedTag}";
    in
    pkgs.writeShellScriptBin name ''
      exec podman run --rm -i \
      ${volumeArgs} \
      ${customArgs} \
      ${fullImage} "$@"
    '';
}
