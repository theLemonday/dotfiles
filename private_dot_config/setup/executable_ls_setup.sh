dpkg -l | grep ninja-build
installed=$?
if [[ $installed == "" ]]; then
    sudo apt-get install ninja-build
else
    # clone project
    git clone https://github.com/sumneko/lua-language-server
    cd lua-language-server
    git submodule update --init --recursive

    #build
    cd 3rd/luamake
    ./compile/install.sh
    cd ../..
    ./3rd/luamake/luamake rebuild
fi
