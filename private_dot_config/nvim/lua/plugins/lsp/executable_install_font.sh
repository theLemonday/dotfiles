fc-list | grep JetBrainsMono-Regular.ttf
installed=$?
if [[ $installed == "" ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
else
    echo "font installed"
fi
