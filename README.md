# Lemonday dotfiles

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate --no-confirm # Install determinate nix
nix shell nixpkgs#nh
# nix run home-manager/master -- init --switch # Setup home manager
nh home switch -c personal .

# create files for zsh
touch ~/.config/zsh/conf.d/env.zsh

# avoid interference with user-dirs
mv ~/.config/user-dirs.dirs ~/.config/user-dirs.dirs.bak
```

Configure tms.

```sh
tms config --paths ~/Documents/ ~/.config
```

Add the shells to the list `/etc/shells`. And change the shell.

If the switch command failed, to expose the hidden errors

```sh
nix build .#homeConfigurations.personal.activationPackage && ./result/activate
```
