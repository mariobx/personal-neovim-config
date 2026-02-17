#!/bin/bash
# run 
#curl -LO https://raw.githubusercontent.com/mariobx/personal-neovim-config/main/neovim_installer_setup.sh && chmod +x neovim_installer_setup.sh && ./neovim_installer_setup.sh

set -e 

# CONFIG
GITHUB_USER="mariobx" 
REPO="personal-neovim-config"
BRANCH="main"
NVIM_CONFIG_DIR="$HOME/.config/nvim"

install_arch() {
    echo "Detected Arch Linux..."
    sudo pacman -S --noconfirm neovim git ripgrep fd base-devel unzip wget npm
}

install_debian() {
    echo "Detected Debian/Ubuntu..."
    # 1. Install dependencies via apt (but NOT neovim)
    sudo apt update
    sudo apt install -y git ripgrep fd-find build-essential unzip wget nodejs npm curl

    # 2. Install Neovim (AppImage) because apt repos are ancient
    echo "Downloading latest Neovim AppImage..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
    chmod u+x nvim.appimage
    sudo mv nvim.appimage /usr/local/bin/nvim
    
    # Symlink fd-find to fd 
    if ! command -v fd &> /dev/null; then
        sudo ln -s $(which fdfind) /usr/local/bin/fd
    fi
}

# 1. DETECT OS AND INSTALL
if [ -f /etc/arch-release ]; then
    install_arch
elif [ -f /etc/debian_version ]; then
    install_debian
else
    echo "Unsupported OS."
    exit 1
fi

# 2. BACKUP EXISTING CONFIG
if [ -f "$NVIM_CONFIG_DIR/init.lua" ]; then
    echo "Backing up existing init.lua..."
    mv "$NVIM_CONFIG_DIR/init.lua" "$NVIM_CONFIG_DIR/init.lua.bak"
fi
mkdir -p "$NVIM_CONFIG_DIR"

# 3. DOWNLOAD CONFIG
RAW_URL="https://raw.githubusercontent.com/$GITHUB_USER/$REPO/$BRANCH/init.lua"
echo "Pulling config from $RAW_URL..."
curl -fLo "$NVIM_CONFIG_DIR/init.lua" "$RAW_URL"

# 4. SYNC PLUGINS
if ! command -v nvim &> /dev/null; then
    echo "Error: Neovim installation failed."
    exit 1
fi

nvim --headless "+Lazy! sync" +qa
echo "Done."
