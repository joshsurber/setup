#! /bin/bash
sudo pacman -S --needed - < ./pkgs.arch
bat cache --build

mkdir -p ~/Desktop ~/Documents ~/Downloads ~/Google ~/Music ~/Pictures ~/Projects ~/Public ~/Templates ~/Videos ~/.config/rclone
cat rclone.txt > ~/.config/rclone/rclone.conf
rclone config reconnect drive:

make

echo 'source ~/.bash/source' >> ~/.bashrc
echo 'source ~/.bash/profile' >> ~/.profile
echo 'source ~/.bash/logout' >> ~/.bash_logout

sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
yay -Y --gendb
yay -Syu --devel
yay -Y --devel --save
cd ..
rm -rf yay
