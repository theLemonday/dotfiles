# theLemonday dotfiles

## Setup on new machine

Install chezmoi dotfiles managing tool

```sh
sh -c "$(curl -fsLS chezmoi.io/get)"
```

Clone dotfiles by chezmoi 

```sh
chezmoi init --apply https://github.com/theLemonday/dotfiles
```

## Fedora setup
Package install
- clang
- zsh
- sqlite
- go
- dconf-editor

```sh
sudo dnf install clang zsh sqlite go dconf-editor fira-code-fonts
```

## Rust setup

Install rust script
```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Install rust tool crate
- xplr
- stylua
- exa
- vivid
- ripgrep

```sh
cargo install --locked --force xplr

cargo install stylua exa vivid ripgrep
```

## Nvm && npm
1. Install nvm
```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
```
2. Restart shell and install npm
```sh
nvm install --lts
```

## Powerline && Nerd font setup
