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
if ! command -v nvim &>/dev/null; then
	echo "Installing neovim..."
	sudo add-apt-repository -y ppa:neovim-ppa/stable
	sudo apt update && sudo apt install -y neovim
else
	echo "neovim is already installed."
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

if ! grep -q "base16-shell" "$HOME/.config/fish/config.fish"; then
	echo "Configuring Base16 Shell for Fish..."
	echo -e "\n# Base16 Shell\nset -x BASE16_SHELL \"$BASE16_SHELL_DIR\"\n. \$BASE16_SHELL/profile_helper.fish" >>"$HOME/.config/fish/config.fish"
else
	echo "Base16 Shell is already configured for Fish."
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
