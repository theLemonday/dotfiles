# AGENTS.md

Home Manager flake for one non-NixOS Linux user (`southclementide`). Two profiles: `personal` and `work`, both built from `home.nix` + `modules/common`.

## Commands

- Preview changes: `nh home switch -n -c personal .`
- Apply personal: `nh home switch -c personal .`
- Evaluate without building: `nix eval --raw .#homeConfigurations.personal.activationPackage.drvPath`
- Debug a failed activation (from README): `nix build .#homeConfigurations.personal.activationPackage && ./result/activate`
- There is no test suite, linter, formatter, or CI. Verify by evaluating/building the config; do not invent other commands.
- The flake attr names are literally `personal` / `work`, so `-c` is required.

## Module layout

- `modules/common/` applies to both profiles; `modules/personal/` and `modules/work/` are profile-only.
- Each `modules/*/default.nix` auto-imports every sibling `.nix` file (except `default.nix`). Add a file in the right directory; no import registration needed.
- Shared helpers/inputs come from `flake.nix` via `extraSpecialArgs` (`helpers`, `inputs`). Use `helpers.mkPodmanWrapper` for containerized CLI tools.
- Put shared packages in `modules/common`, profile-specific ones in the matching profile; keep `home.nix` for base config only.
- `unused/` is dead code not referenced by the flake. `utils/mkSectionList.nix` is also currently unused.
- `scripts/` is on `home.sessionPath`; files there are run directly.

## Gotchas

- `home.stateVersion = "25.05"` and the `flake.lock` pins (nixpkgs unstable, home-manager master) are intentional. Do not bump them unless asked.
- `allowUnfree = true` is set in `flake.nix`.
- This is generic Linux (non-NixOS): the personal profile wraps GUI apps with nixGL (`config.lib.nixGL.wrap`, `targets.genericLinux.nixGL`). Keep work-profile changes free of nixGL assumptions.
- Secrets use sops-nix: age key at `~/.config/sops/age/keys.txt`, default file `secrets/secrets.yml`, creation rule `secrets/*.yaml|yml`. Edit with `sops secrets/secrets.yml`; never hand-edit `ENC[...]` values. Declare secrets in `home.nix` under `sops.secrets`.
- Known breakage: `modules/work/git.nix:4` references `config.sops.secrets."work_git_config"`, but its declaration is commented out at `home.nix:19-21`. The `work` config fails evaluation with `attribute 'work_git_config' missing`; restore the declaration before expecting it to build.
- Host-level setup is manual and not managed here: Nix/determinate install, `/etc/shells`, podman socket/user services, `tms` config. See `README.md`.
