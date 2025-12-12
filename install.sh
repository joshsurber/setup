#! /bin/bash
# vim: ft=bash fdm=indent wrap

system="base-devel xclip zip cups fuse2 fuse3 ghostty git gvfs gvfs-smb keyd make man-db moreutils npm pamixer pkgfile unzip xdg-user-dirs "

XorgWM="arandr autorandr autotiling clipmenu dunst i3 nitrogen maim picom polybar polybar rofi rofi-calc rofi-emoji rofimoji"

hypr="cliphist hypridle hyprland hyprlock hyprpaper hyprpicker hyprshot swaync waybar wl-clipboard"

apps="brightnessctl chromium eza fish fzf kitty lazygit neovide neovim noto-fonts-emoji rclone ripgrep starship stow thunar tldr tmux ttf-cascadia-code-nerd ttf-firacode-nerd ttf-roboto vifm xarchiver zoxide"

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

if has pacman; then
    install="sudo pacman -S --needed"
    distro="fd bat bat-extras"
elif has apt; then
    install="sudo apt install"
    disto="fdfind batcat"
    curl -sS https://starship.rs/install.sh | sh
fi

$install $system $hypr $apps $distro
git clone --recursive git@github.com:joshsurber/.files
cd .files

if has bat; then
    bat cache --build
elif has batcat; then
    bat cache --build
fi

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
    rm -rf yay
elif has apt; then
    # curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    # sudo rm -rf /opt/nvim-linux64
    # sudo tar -C /opt -xzf nvim-linux64.tar.gz
    # rm nvim-linux64.tar.gz
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install neovim
fi
