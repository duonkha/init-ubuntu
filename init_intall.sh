#!/bin/bash

# ==================== Update and Upgrade ====================
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y

# ==================== Install Prerequisites ====================
echo "Installing prerequisites..."
sudo apt install -y software-properties-common curl git

# ==================== Fish Shell ====================
if ! command -v fish &>/dev/null; then
	echo "Installing fish..."
	sudo add-apt-repository -y ppa:fish-shell/release-3
	sudo apt update && sudo apt install -y fish
else
	echo "fish is already installed."
fi

# Ensure Fish config directory and file exist
FISH_CONFIG_DIR="$HOME/.config/fish"
FISH_CONFIG_FILE="$FISH_CONFIG_DIR/config.fish"
if [ ! -d "$FISH_CONFIG_DIR" ]; then
	echo "Creating Fish config directory..."
	mkdir -p "$FISH_CONFIG_DIR"
fi
if [ ! -f "$FISH_CONFIG_FILE" ]; then
	echo "Creating Fish config file..."
	touch "$FISH_CONFIG_FILE"
fi

# ==================== Tmux ====================
if ! command -v tmux &>/dev/null; then
	echo "Installing tmux..."
	sudo apt install -y tmux
else
	echo "tmux is already installed."
fi

# Install Tmux Plugin Manager (TPM)
TMUX_PLUGIN_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TMUX_PLUGIN_DIR" ]; then
	echo "Installing Tmux Plugin Manager (TPM)..."
	git clone https://github.com/tmux-plugins/tpm "$TMUX_PLUGIN_DIR"
else
	echo "TPM is already installed."
fi

# ==================== Git ====================
if ! command -v git &>/dev/null; then
	echo "Installing git..."
	sudo apt install -y git
else
	echo "git is already installed."
fi

# ==================== Tig ====================
if ! command -v tig &>/dev/null; then
	echo "Installing tig..."
	sudo apt install -y tig
else
	echo "tig is already installed."
fi

# ==================== Neovim ====================
if ! command -v nvim &> /dev/null; then
  echo "Installing latest prebuilt Neovim..."
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux64.tar.gz
  
  if ! grep -q '/opt/nvim-linux64/bin' "$HOME/.bashrc"; then
    echo "export PATH=\"\$PATH:/opt/nvim-linux64/bin\"" >> "$HOME/.bashrc"
  fi
  
  if ! grep -q '/opt/nvim-linux64/bin' "$FISH_CONFIG_FILE"; then
    echo "Adding Neovim to Fish shell PATH..."
    echo "set -Ux PATH \$PATH /opt/nvim-linux64/bin" >> "$FISH_CONFIG_FILE"
  fi
else
  echo "neovim is already installed."
fi

# ==================== LazyVim ====================
LAZYVIM_DIR="$HOME/.config/nvim"
if [ ! -d "$LAZYVIM_DIR" ]; then
  echo "Installing LazyVim..."
  git clone https://github.com/LazyVim/starter $LAZYVIM_DIR
else
  echo "LazyVim is already installed."
fi

# ==================== Tide Prompt ====================
if ! command -v fisher &>/dev/null; then
	echo "Installing Fisher package manager for fish..."
	fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
else
	echo "Fisher is already installed."
fi

if ! fish -c "fisher list | grep -q tide"; then
	echo "Installing Tide prompt for fish..."
	fish -c "fisher install IlanCosman/tide@v5"
	echo "Running Tide configuration..."
	fish -c "tide configure"
else
	echo "Tide prompt is already installed and configured."
fi

# ==================== Base16 Shell ====================
BASE16_SHELL_DIR="$HOME/.config/base16-shell"
if [ ! -d "$BASE16_SHELL_DIR" ]; then
	echo "Installing Base16 Shell..."
	git clone https://github.com/chriskempson/base16-shell.git "$BASE16_SHELL_DIR"
else
	echo "Base16 Shell is already installed."
fi

if ! grep -q "base16-shell" "$FISH_CONFIG_FILE"; then
	echo "Configuring Base16 Shell for Fish..."
	echo -e "\n# Base16 Shell\nset -x BASE16_SHELL \"$BASE16_SHELL_DIR\"\n. \$BASE16_SHELL/profile_helper.fish" >>"$FISH_CONFIG_FILE"
else
	echo "Base16 Shell is already configured for Fish."
fi

# ==================== FZF ====================
if ! command -v fzf &> /dev/null; then
  echo "Installing FZF..."
  sudo apt install -y fzf
else
  echo "FZF is already installed."
fi

# ==================== Post-installation ====================

# Set fish as default shell if not already
if [ "$SHELL" != "$(which fish)" ]; then
	echo "Setting fish as the default shell..."
	chsh -s $(which fish)
fi

# Clean up
echo "Cleaning up unnecessary packages..."
sudo apt autoremove -y

echo "Installation complete. Please restart your terminal to apply changes."
