#!/usr/bin/env bash
set -euo pipefail

# This script installs Nix using the DeterminateSystems nix-installer (without installing Determinate)
# and then sets up nix-darwin on macOS using flakes.
#
# Prerequisites:
# - Running on macOS.
# - A modern version of Nix (>=2.4) with flake support enabled.
#   To enable flakes, add the following to your ~/.config/nix/nix.conf:
#     experimental-features = nix-command flakes

# Ensure we are running on macOS.
if [[ "$(uname)" != "Darwin" ]]; then
	echo "Error: This installer is only supported on macOS."
	exit 1
fi

echo "Setting ComputerName, HostName, and LocalHostname."
sudo scutil --set ComputerName "macintosh"
sudo scutil --set HostName "macintosh"
sudo scutil --set LocalHostName "macintosh"

echo "Installing HomeBrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [[ "$(uname -m)" == "arm64" ]]; then
	echo "Running on Apple Silicon (arm64)."
	if /usr/bin/pgrep oahd >/dev/null 2>&1; then
		echo "Rosetta 2 not found. Installing..."
		/bin/zsh -c 'softwareupdate --install-rosetta --agree-to-license'
		if [[ $? -eq 0 ]]; then
			echo "Rosetta 2 installation successful."
		else
			echo "Rosetta 2 installation failed."
		fi
	fi
else
	echo "This Mac is not running Apple Silicon. No need for Rosetta"
fi

# Check if Xcode Command Line Tools are installed (for Git).
if ! xcode-select -p >/dev/null 2>&1; then
	echo "Xcode Command Line Tools not found. Installing..."
	/bin/zsh -c 'xcode-select --install'

	echo "Please follow the on-screen instructions to complete the installation."
	# Wait for the installation to complete.
	until xcode-select -p >/dev/null 2>&1; do
		sleep 5
	done
	echo "Xcode Command Line Tools installed."
else
	echo "Xcode Command Line Tools are already installed."
fi

echo "Cloning the nix-darwin-flake repository https://github.com/Malikiah/nix-darwin-flake.git."
sudo git clone https://github.com/Malikiah/nix-darwin-flake.git /etc/nix-darwin

sudo chown -R ${whoami}:staff /etc/nix-darwin

# Check if Nix is installed.
if ! command -v nix >/dev/null 2>&1; then
	echo "Nix is not installed. Installing Nix using the DeterminateSystems nix-installer..."
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

	# Attempt to source the Nix profile if available.
	if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
		. "$HOME/.nix-profile/etc/profile.d/nix.sh"
	else
		echo "Warning: Unable to load the Nix environment automatically. You may need to restart your shell."
	fi
else
	echo "Nix is already installed."
fi

# Check if flakes are enabled (optional warning).
NIX_CONF="$HOME/.config/nix/nix.conf"
if ! grep -q "experimental-features" "$NIX_CONF" 2>/dev/null; then
	echo "Warning: Nix flakes may not be enabled. Please ensure your $NIX_CONF includes:"
	echo "  experimental-features = nix-command flakes"
fi

# Install nix-darwin using Nix flakes from the DeterminateSystems/nix-darwin repository.
echo "Building nix-darwin installer..."
/bin/zsh -c 'nix run nix-darwin/master#darwin-rebuild -- switch'

echo "nix-darwin installation complete."
yabai --start-service
skhd --start-service

echo "Reboot System"
