#!/bin/bash

# 1. Install Neovim and common 'bs' dependencies
# You need git for plugins, ripgrep/fd for telescope, and build tools for LSPs.
echo "Installing Neovim and essential dependencies..."
sudo pacman -S --noconfirm neovim git ripgrep fd base-devel unzip wget nodejs npm

# 2. Create the config directory if it doesn't exist
NVIM_CONFIG_DIR="$HOME/.config/nvim"
mkdir -p "$NVIM_CONFIG_DIR"

# 3. Download your init.lua from GitHub
# Using the raw URL to avoid getting the HTML wrapper
RAW_URL="https://raw.githubusercontent.com/mariobx/personal-neovim-config/main/init.lua"

echo "Pulling config from $RAW_URL..."
curl -fLo "$NVIM_CONFIG_DIR/init.lua" "$RAW_URL"

# 4. Handle the "other bs" (Plugin Manager)
# Most modern configs (like yours likely does) use 'lazy.nvim'.
# This command ensures the data directory for plugins exists.
mkdir -p "$HOME/.local/share/nvim/site"

echo "Setup complete. Launching Neovim to sync plugins..."
nvim --headless "+Lazy! sync" +qa
