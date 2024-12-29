#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit
fi

# Update and upgrade the system
apt update && apt upgrade -y

# Install prerequisites
apt install -y software-properties-common curl git

# ==================== Fish Shell ====================
if ! command -v fish &>/dev/null; then
	echo "Installing fish..."
	add-apt-repository -y ppa:fish-shell/release-3
	apt update && apt install -y fish
else
	echo "fish is already installed."
fi

# ==================== Tmux ====================
if ! command -v tmux &>/dev/null; then
	echo "Installing tmux..."
	apt install -y tmux
else
	echo "tmux is already installed."
fi

# ==================== Git ====================
if ! command -v git &>/dev/null; then
	echo "Installing git..."
	apt install -y git
else
	echo "git is already installed."
fi

# ==================== Tig ====================
if ! command -v tig &>/dev/null; then
	echo "Installing tig..."
	apt install -y tig
else
	echo "tig is already installed."
fi

# ==================== Neovim ====================
if ! command -v nvim &>/dev/null; then
	echo "Installing neovim..."
	add-apt-repository -y ppa:neovim-ppa/stable
	apt update && apt install -y neovim
else
	echo "neovim is already installed."
fi

# ==================== Starship Prompt ====================
if ! command -v starship &>/dev/null; then
	echo "Installing Starship prompt..."
	curl -sS https://starship.rs/install.sh | sh -s -- -y
else
	echo "Starship prompt is already installed."
fi

# Configure Starship for fish
CONFIG_FISH_PATH=~/.config/fish/config.fish
if [ -f "$CONFIG_FISH_PATH" ]; then
	if ! grep -Fxq "starship init fish | source" "$CONFIG_FISH_PATH"; then
		echo "Configuring Starship prompt for fish..."
		mkdir -p ~/.config/fish
		echo 'starship init fish | source' >>"$CONFIG_FISH_PATH"
	else
		echo "Starship prompt is already configured for fish."
	fi
else
	echo "Creating config.fish and configuring Starship prompt for fish..."
	mkdir -p ~/.config/fish
	echo 'starship init fish | source' >"$CONFIG_FISH_PATH"
fi

# ==================== Post-installation ====================

# Set fish as default shell if not already
if [ "$SHELL" != "$(which fish)" ]; then
	echo "Setting fish as the default shell..."
	chsh -s $(which fish)
fi

# Clean up
apt autoremove -y

echo "Installation complete. Please restart your terminal to apply changes."
