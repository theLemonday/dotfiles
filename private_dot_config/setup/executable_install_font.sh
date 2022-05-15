/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

echo "[-] Download fonts [-]"
echo "Nonicons"
wget https://github.com/yamatsum/nonicons/blob/master/dist/nonicons.ttf --directory-prefix ~/.local/share/fonts/
fc-cache -fv
echo "done!"
