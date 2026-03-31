# Lemonday dotfiles

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate --no-confirm # Install determinate nix
nix shell nixpkgs#nh
# nix run home-manager/master -- init --switch # Setup home manager
nh home switch -c personal .
```
