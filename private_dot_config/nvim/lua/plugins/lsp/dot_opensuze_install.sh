rpm -qa | grep lua-language-server
installed=$?
if [[ $installed == "" ]]; then
    sudo zypper addrepo https://download.opensuse.org/repositories/devel:languages:lua/openSUSE_Tumbleweed/devel:languages:lua.repo
    sudo zypper refresh
    sudo zypper install lua-language-server
fi
