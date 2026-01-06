#! /bin/bash
# vim: ft=bash fdm=indent wrap

# system="base-devel xclip zip cups fuse2 fuse3 ghostty git gvfs gvfs-smb keyd make man-db moreutils npm pamixer pkgfile unzip xdg-user-dirs "
# hypr="cliphist hypridle hyprland hyprlock hyprpaper hyprpicker hyprshot swaync waybar wl-clipboard"
# apps="ghostty make eza fish fzf lazygit noto-fonts-emoji ripgrep stow tldr tmux ttf-cascadia-code-nerd ttf-firacode-nerd ttf-roboto vifm zoxide"

aptinstall='wl-clipboard kitty git'
brewinstall='eza fish fd bat bat-extras fzf lazygit make neovim ripgrep stow tldr tmux'

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

sudo apt install $aptinstall

# return
git clone --recursive git@github.com:joshsurber/.files
cd .files

if has bat; then
    bat cache --build
elif has batcat; then
    bat cache --build
fi

mkdir -p ~/Projects
make

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install $brewinstall
curl -L https://bit.ly/n-install | bash
