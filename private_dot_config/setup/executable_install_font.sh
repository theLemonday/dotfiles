/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

echo "[-] Download fonts [-]"
echo "Nonicons"
wget https://github.com/yamatsum/nonicons/blob/master/dist/nonicons.ttf --directory-prefix ~/.local/share/fonts/

echo 'RobotoMono Nerd font'
wget https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/RobotoMono/Medium/complete/Roboto%20Mono%20Medium%20Nerd%20Font%20Complete.ttf --directory-prefix ~/.local/share/fonts/
fc-cache -fv
echo "done!"

