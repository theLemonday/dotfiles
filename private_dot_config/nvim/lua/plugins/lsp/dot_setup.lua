source ./os_detect.sh
if [[ $OS == "openSUSE Tumbleweed" ]]; then
    ./opensuse_install
elif [[ $OS == "Ubuntu" ]]; then
    ./ubuntu_install
fi
