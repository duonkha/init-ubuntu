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

# ==================== Tide Prompt ====================
if ! command -v fisher &>/dev/null; then
	echo "Installing Fisher package manager for fish..."
	curl -sL https://git.io/fisher | source && fish -c "fisher install jorgebucaran/fisher"
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

# ==================== Post-installation ====================

# Set fish as default shell if not already
if [ "$SHELL" != "$(which fish)" ]; then
	echo "Setting fish as the default shell..."
	chsh -s $(which fish)
fi

# Clean up
apt autoremove -y

echo "Installation complete. Please restart your terminal to apply changes."
