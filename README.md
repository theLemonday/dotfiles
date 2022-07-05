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

## Fedora 36 setup
Package install
- clang
- zsh
- sqlite
- go
- dconf-editor

```sh
sudo dnf install clang zsh sqlite go dconf-editor fira-code-fonts python3-pip
```

Install ibus-bamboo
```sh
# add repo
dnf config-manager --add-repo https://download.opensuse.org/repositories/home:lamlng/Fedora_36/home:lamlng.repo
# install bamboo
dnf install ibus-bamboo
```

### Using fedora
All fedora repo are under /etc/yum.repos.d/ so to see all repo use command
```sh
exa /etc/yum.repos.d/
```

## Rust setup

Install rust script
```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## Python-base tool setup
```sh
# Install pynvim for neovim
python3 -m pip install --user pynvim virtualenv virtualenvwrapper
```

## Shell setup
Require zsh installed
```sh
# change zsh default shell
chsh -s $(which zsh)

# install starship shell
curl -sS https://starship.rs/install.sh | sh
```

## Terminal tools
- xplr
- stylua
- exa
- vivid
- ripgrep
- **Tokei** is a program that displays statistics about your code. Tokei will show the number of files, total lines within those files and code, comments, and blanks grouped by language.
- **bat** is cat(1) clone with syntax highlighting and Git integration.
- zoxide is a smarter cd command, inspired by z and autojump.

```sh
cargo install --locked --force xplr

cargo install stylua exa vivid ripgrep

#zoxide
curl -sS https://webinstall.dev/zoxide | bash

# fedora install
dnf install fd-find tokei bat
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
Make font dir
```sh
mkdir -p ~/.local/share/fonts
```
Fira code nerd font
```sh
z ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip
rm FiraCode.zip
fc-cache -fv
```
