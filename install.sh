#! /bin/bash
# vim: ft=bash fdm=indent wrap
set -e
#only needed on arch
arch="base-devel zip cups fuse2 fuse3 ghostty gvfs gvfs-smb man-db moreutils npm pamixer pkgfile unzip xdg-user-dirs noto-fonts-emoji ttf-cascadia-code-nerd ttf-firacode-nerd ttf-roboto"
# always install via pkg manager
system=" git make stow"
# always install; pkgmgr on arch, brew on deb/chromeos
utils=" bat bat-extras eza fd fish fzf lazygit moreutils neovim starship ripgrep tldr tmux vifm zoxide xclip "
xutils=" xclip arandr autorandr brightnessctl autotiling clipmenu dunst nitrogen maim picom polybar polybar rofi rofi-calc rofi-emoji rofimoji "
wutils="cliphist hypridle hyprland hyprlock hyprpaper hyprpicker hyprshot swaync waybar wl-clipboard "
apps=" chromium kitty neovide rclone thunar xarchiver "
i3=" i3 "
hypr="hyprland"
awesome="awesome"

# 1. Display the options to the user
echo "Select a Window Manager, default is none"
echo "1) none"
echo "2) Hyprland"
echo "3) i3"
echo "4) awesome"

# 2. Read user input
# -p: prompt string
# -r: prevents backslashes from acting as escape characters
read -p "Enter choice [1-4]: " choice
# 3. Set the default if input is empty
choice=${choice:-1}

# 4. Set variables based on choice
case $choice in
  1) stuff="$system" ;;
  2) stuff="$system $wutils $hypr $apps" ;;
  3) stuff="$system $i3 $xutils $apps" ;;
esac
  4) stuff="$system $awesome $xutils $apps" ;;

has() {
    command -v "$1" 1>/dev/null 2>&1
}
if ! sudo -v; then
    error "Superuser not granted, aborting installation"
    exit 1
fi

git remote set-url origin git@github.com:joshsurber/setup.git
cp ssh.tar.gpg ~
cd ~
gpg ssh.tar.gpg
tar xf ssh.tar
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*

if has pacman; then
    sudo pacman -S --needed $stuff $arch $utils
elif has apt; then
    sudo apt update && sudo apt upgrade
    sudo apt install $stuff
fi

git clone --recursive git@github.com:joshsurber/.files
cd .files

mkdir -p ~/Google ~/Projects ~/.config/rclone
cat rclone.txt >~/.config/rclone/rclone.conf
xdg-user-dirs-update
rclone config reconnect drive:
rm -rf ~/.config/hypr
make
sudo mkdir /etc/keyd
sudo ln keyd.conf /etc/keyd/default.conf

echo 'source ~/.bash/source' >>~/.bashrc
echo 'source ~/.bash/profile' >>~/.profile
echo 'source ~/.bash/logout' >>~/.bash_logout

if has pacman && ! has yay; then
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si
    yay -Y --gendb
    yay -Syu --devel
    yay -Y --devel --save
    cd ..
    rm -rf yay-bin
elif has apt; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install $utils
    curl -L https://bit.ly/n-install | bash
fi
bat cache --build
