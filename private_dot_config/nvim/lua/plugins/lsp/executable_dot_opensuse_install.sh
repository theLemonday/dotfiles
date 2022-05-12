rpm -qa | grep lua-language-server
installed=$?
if [[ $installed == "" ]]; then
    sudo zypper addrepo https://download.opensuse.org/repositories/devel:languages:lua/openSUSE_Tumbleweed/devel:languages:lua.repo
    sudo zypper refresh
    sudo zypper install lua-language-server
else
    echo "lua-language-server installed"
fi

rpm -qa | grep sqlite3
installed=$?
if [[ $installed == "" ]]; then
    sudo zypper addrepo https://download.opensuse.org/repositories/server:database/openSUSE_Tumbleweed/server:database.repo
    sudo zypper refresh
    sudo zypper install sqlite3
else
    echo "sqlite3 installed"
fi

sudo zypper in zsh
chsh -s $(which zsh)
wget -O - https://raw.githubusercontent.com/denysdovhan/spaceship-zsh-theme/master/install.zsh | zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
