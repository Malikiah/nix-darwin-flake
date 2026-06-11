#!/usr/bin/env bash

# Re-exec under bash if started by a non-bash /bin/sh. When piped (no script
# file on disk) we re-fetch ourselves through bash instead of trying to run a
# nonexistent "$0". On macOS /bin/sh is already bash, so this is usually a no-op.
if [ -z "${BASH_VERSION:-}" ]; then
	exec bash -c 'curl --proto "=https" --tlsv1.2 -fsSL https://raw.githubusercontent.com/Malikiah/nix-darwin-flake/refs/heads/main/nix-darwin-installer.sh | bash'
fi

set -euo pipefail

# This script installs / repairs a nix-darwin setup on macOS using flakes.
#
# Run it directly from GitHub:
#   curl https://raw.githubusercontent.com/Malikiah/nix-darwin-flake/refs/heads/main/nix-darwin-installer.sh | sh
#
# It is fully idempotent: every component is independently validated and only
# (re)installed when it is actually missing or broken. Re-running the script on
# a partially-installed or corrupted machine will fill in whatever is missing
# and then always be able to run `darwin-rebuild switch`.
#
# Components validated:
#   - macOS
#   - Nix (with flakes enabled)
#   - Homebrew
#   - Rosetta 2 (Apple Silicon only)
#   - Xcode Command Line Tools (for git)
#   - The nix-darwin flake repository
#   - darwin-rebuild

NIX_DARWIN_REPO="https://github.com/Malikiah/nix-darwin-flake.git"
NIX_DARWIN_DIR="/etc/nix-darwin"
NIX_INSTALLER_URL="https://install.determinate.systems/nix"
NIX_CONF="$HOME/.config/nix/nix.conf"

log()  { echo "==> $*"; }
warn() { echo "WARN: $*" >&2; }
fail() { echo "ERROR: $*" >&2; exit 1; }

# Load the Nix environment into the current shell if present. Nix's profile
# script does not play nicely with `set -u`, so relax it while sourcing.
load_nix_env() {
	local daemon="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
	local user="$HOME/.nix-profile/etc/profile.d/nix.sh"
	set +u
	if [ -f "$daemon" ]; then
		. "$daemon"
	elif [ -f "$user" ]; then
		. "$user"
	fi
	set -u
}

# ----------------------------------------------------------------------------
# Preconditions
# ----------------------------------------------------------------------------
[[ "$(uname)" == "Darwin" ]] || fail "This installer is only supported on macOS."

# ----------------------------------------------------------------------------
# Machine identity
# ----------------------------------------------------------------------------
log "Setting ComputerName, HostName, and LocalHostName."
sudo scutil --set ComputerName "macintosh"
sudo scutil --set HostName "macintosh"
sudo scutil --set LocalHostName "macintosh"

# ----------------------------------------------------------------------------
# Nix + flakes
# ----------------------------------------------------------------------------
ensure_nix() {
	load_nix_env
	if command -v nix >/dev/null 2>&1; then
		log "Nix is already installed ($(nix --version 2>/dev/null || echo 'version unknown'))."
	else
		log "Nix not found. Installing via the DeterminateSystems nix-installer..."
		curl --proto '=https' --tlsv1.2 -sSf -L "$NIX_INSTALLER_URL" | sh -s -- install --no-confirm
		load_nix_env
		command -v nix >/dev/null 2>&1 || fail "Nix installation did not produce a working 'nix' binary. Restart your shell and re-run."
	fi
}

ensure_flakes() {
	mkdir -p "$(dirname "$NIX_CONF")"
	if ! grep -qs "experimental-features.*nix-command.*flakes" "$NIX_CONF"; then
		log "Enabling flakes in $NIX_CONF."
		echo "experimental-features = nix-command flakes" >> "$NIX_CONF"
	else
		log "Flakes already enabled in $NIX_CONF."
	fi
}

# ----------------------------------------------------------------------------
# Homebrew
# ----------------------------------------------------------------------------
ensure_homebrew() {
	# Make brew visible to this shell on both Apple Silicon and Intel.
	if [ -x /opt/homebrew/bin/brew ]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	elif [ -x /usr/local/bin/brew ]; then
		eval "$(/usr/local/bin/brew shellenv)"
	fi

	if command -v brew >/dev/null 2>&1; then
		log "Homebrew is already installed ($(brew --version | head -n1))."
	else
		log "Homebrew not found. Installing..."
		NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		if [ -x /opt/homebrew/bin/brew ]; then
			eval "$(/opt/homebrew/bin/brew shellenv)"
		elif [ -x /usr/local/bin/brew ]; then
			eval "$(/usr/local/bin/brew shellenv)"
		fi
		command -v brew >/dev/null 2>&1 || fail "Homebrew installation did not produce a working 'brew' binary."
	fi
}

# ----------------------------------------------------------------------------
# Rosetta 2 (Apple Silicon only)
# ----------------------------------------------------------------------------
ensure_rosetta() {
	if [[ "$(uname -m)" != "arm64" ]]; then
		log "Not Apple Silicon; Rosetta 2 not required."
		return
	fi

	# oahd is the Rosetta translation daemon. If it is registered/running,
	# Rosetta is installed.
	if /usr/bin/pgrep oahd >/dev/null 2>&1 || [ -d /Library/Apple/usr/share/rosetta ]; then
		log "Rosetta 2 is already installed."
	else
		log "Rosetta 2 not found. Installing..."
		if softwareupdate --install-rosetta --agree-to-license; then
			log "Rosetta 2 installation successful."
		else
			warn "Rosetta 2 installation failed. Some x86_64 software may not run."
		fi
	fi
}

# ----------------------------------------------------------------------------
# Xcode Command Line Tools (needed for git)
# ----------------------------------------------------------------------------
ensure_xcode_clt() {
	if xcode-select -p >/dev/null 2>&1 && command -v git >/dev/null 2>&1; then
		log "Xcode Command Line Tools are already installed."
	else
		log "Xcode Command Line Tools not found. Installing..."
		xcode-select --install >/dev/null 2>&1 || true
		log "Please follow the on-screen instructions to complete the installation."
		until xcode-select -p >/dev/null 2>&1 && command -v git >/dev/null 2>&1; do
			sleep 5
		done
		log "Xcode Command Line Tools installed."
	fi
}

# ----------------------------------------------------------------------------
# nix-darwin flake repository
# ----------------------------------------------------------------------------
ensure_repo() {
	# If a config already exists, leave it completely untouched — do not clone,
	# overwrite, or re-chown. We only ensure the tooling can run against it.
	if [ -e "$NIX_DARWIN_DIR/flake.nix" ]; then
		log "nix-darwin flake already present at $NIX_DARWIN_DIR; leaving existing files untouched."
		return
	fi

	if [ -d "$NIX_DARWIN_DIR/.git" ]; then
		warn "$NIX_DARWIN_DIR is a git repo but flake.nix is missing; leaving it untouched."
		return
	fi

	# Fresh machine: nothing here yet, so it is safe to clone and take ownership.
	log "No existing config found. Cloning nix-darwin flake into $NIX_DARWIN_DIR."
	sudo git clone "$NIX_DARWIN_REPO" "$NIX_DARWIN_DIR"
	sudo chown -R "$(whoami):staff" "$NIX_DARWIN_DIR"
}

# ----------------------------------------------------------------------------
# Final preflight: confirm everything is in place before rebuilding.
# ----------------------------------------------------------------------------
preflight() {
	log "Running preflight validation..."
	local ok=1
	load_nix_env

	command -v nix   >/dev/null 2>&1 || { warn "nix is missing.";   ok=0; }
	command -v brew  >/dev/null 2>&1 || { warn "brew is missing.";  ok=0; }
	command -v git   >/dev/null 2>&1 || { warn "git is missing.";   ok=0; }
	xcode-select -p  >/dev/null 2>&1 || { warn "Xcode CLT missing."; ok=0; }
	grep -qs "flakes" "$NIX_CONF"    || { warn "flakes not enabled."; ok=0; }
	[ -e "$NIX_DARWIN_DIR/flake.nix" ] || { warn "flake.nix missing at $NIX_DARWIN_DIR."; ok=0; }

	if [[ "$(uname -m)" == "arm64" ]]; then
		if ! /usr/bin/pgrep oahd >/dev/null 2>&1 && [ ! -d /Library/Apple/usr/share/rosetta ]; then
			warn "Rosetta 2 not detected."
			ok=0
		fi
	fi

	[ "$ok" -eq 1 ] || fail "Preflight validation failed. Re-run this script to repair the missing components above."
	log "Preflight validation passed."
}

# ----------------------------------------------------------------------------
# Build / switch
# ----------------------------------------------------------------------------
rebuild() {
	load_nix_env
	if command -v darwin-rebuild >/dev/null 2>&1; then
		log "Running darwin-rebuild switch..."
		sudo darwin-rebuild switch --flake "$NIX_DARWIN_DIR"
	else
		log "darwin-rebuild not found yet; bootstrapping via 'nix run nix-darwin'..."
		sudo /bin/zsh -lc "nix run nix-darwin/master#darwin-rebuild -- switch --flake '$NIX_DARWIN_DIR'"
	fi
}

# ----------------------------------------------------------------------------
# Run
# ----------------------------------------------------------------------------
ensure_nix
ensure_flakes
ensure_homebrew
ensure_rosetta
ensure_xcode_clt
ensure_repo
preflight
rebuild

log "nix-darwin installation complete."
printf '\n!Reboot YOUR System!\n\n'
