#! /usr/bin/env bash
sudo apt-get install bash-completion bat command-not-found exa fd-find fish fzf kitty make npm ripgrep shfmt software-properties-common stow tidy tldr xclip

curl -sS https://starship.rs/install.sh | sh
batcat cache --build

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim-linux64
sudo tar -C /opt -xzf nvim-linux64.tar.gz
rm nvim-linux64.tar.gz

make
echo 'source ~/.bash/source' >>~/.bashrc
echo 'source ~/.bash/profile' >>~/.profile
echo 'source ~/.bash/logout' >>~/.bash_logout
