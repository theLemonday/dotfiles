# where's installed current version?
which nvim

# what's current version?
nvim -v

# make tmp folder
mkdir -p ~/tmp
cd ~/tmp

# clone
git clone --depth 1 --branch nightly https://github.com/neovim/neovim.git
cd neovim

# if updating, then just "git pull"

# build and install
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

echo "Installed"
