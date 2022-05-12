#install jetbrains font
./font_install.sh
source ./os_detect.sh
if [[ $OS == "openSUSE Tumbleweed" ]]; then
    ./opensuse_install.sh
elif [[ $OS == "Ubuntu" ]]; then
    ./ubuntu_install.sh
fi


