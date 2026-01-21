#!/bin/bash
set -e # Exit on error

# vim: ft=bash fdm=indent wrap

# Package Definitions
arch_only="base-devel zip cups fuse2 fuse3 ghostty gvfs gvfs-smb man-db moreutils npm pamixer pkgfile unzip xdg-user-dirs noto-fonts-emoji ttf-cascadia-code-nerd ttf-firacode-nerd ttf-roboto"
system_core=" fish git make stow tmux xclip "
utils=" bat bat-extras eza fd fzf lazygit moreutils neovim npm ripgrep starship tldr vifm zoxide "
xutils="xclip arandr autorandr brightnessctl autotiling clipmenu dunst nitrogen maim picom polybar rofi rofi-calc rofi-emoji rofimoji"
wutils="cliphist hypridle hyprland hyprlock hyprpaper hyprpicker hyprshot swaync waybar wl-clipboard"
apps="chromium kitty neovide rclone thunar xarchiver"

echo "Select a Window Manager (default: none):"
echo "1) none | 2) Hyprland | 3) i3 | 4) awesome"
read -p "Enter choice [1-4]: " choice
choice=${choice:-1}

case $choice in
1) stuff="$system_core" ;;
2) stuff="$system_core $wutils hyprland $apps" ;;
3) stuff="$system_core i3 $xutils $apps" ;;
4) stuff="$system_core awesome $xutils $apps" ;;
*)
    echo "Invalid option"
    exit 1
    ;;
esac

has() { command -v "$1" >/dev/null 2>&1; }

# Sudo check
sudo -v

# SSH Setup
if [ -f "ssh.tar.gpg" ]; then
    gpg --decrypt ssh.tar.gpg | tar xf - -C ~
    chmod 700 ~/.ssh && chmod 600 ~/.ssh/*
fi

# System Install
if has pacman; then
    sudo pacman -S --needed $stuff $arch_only $utils
elif has apt; then
    sudo apt update
    sudo apt install -y $stuff
fi

# Dotfiles
if [ ! -d "$HOME/.files" ]; then
    git clone --recursive git@github.com:joshsurber/.files "$HOME/.files"
fi
cd "$HOME/.files"

# Configuration
mkdir -p ~/Google ~/Projects ~/.config/rclone
if has rclone; then
    [ -f rclone.txt ] && cat rclone.txt >~/.config/rclone/rclone.conf
fi
xdg-user-dirs-update
make

# Keyd setup
if has pacman; then
    sudo mkdir -p /etc/keyd
    sudo ln -sf "$(pwd)/keyd.conf" /etc/keyd/default.conf
fi

# AUR / Brew
if has pacman && ! has yay; then
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin && makepkg -si --noconfirm
    cd -
fi

if has apt; then
    if ! has brew; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    /home/linuxbrew/.linuxbrew/bin/brew install $utils
fi

bat cache --build
