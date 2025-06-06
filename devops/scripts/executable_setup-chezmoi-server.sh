#!/bin/bash
# setup-chezmoi-server.sh - Install chezmoi and configure automatic dotfile sync from GitHub

set -euo pipefail

REPO_URL="https://github.com/1tsjeremiah/wingman.git"

# Ensure git
if ! command -v git >/dev/null; then
  echo "[+] Installing git..."
  sudo apt update && sudo apt install -y git
fi

# Ensure curl
if ! command -v curl >/dev/null; then
  echo "[+] Installing curl..."
  sudo apt update && sudo apt install -y curl
fi

# Ensure chezmoi
if ! command -v chezmoi >/dev/null; then
  echo "[+] Installing chezmoi..."
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"
fi

# Initialize or update repo
if [ ! -d "$HOME/.local/share/chezmoi" ]; then
  echo "[+] Initializing chezmoi from $REPO_URL"
  chezmoi init --apply "$REPO_URL"
else
  echo "[+] Updating chezmoi repo"
  cd "$HOME/.local/share/chezmoi"
  git pull --ff-only
  chezmoi apply
fi

# Setup systemd timer for periodic updates
if command -v systemctl >/dev/null; then
  mkdir -p "$HOME/.config/systemd/user"
  cat > "$HOME/.config/systemd/user/chezmoi-update.service" <<SERVICE
[Unit]
Description=Update dotfiles from GitHub via chezmoi

[Service]
Type=oneshot
ExecStart=$HOME/.local/bin/chezmoi update --apply
SERVICE

  cat > "$HOME/.config/systemd/user/chezmoi-update.timer" <<TIMER
[Unit]
Description=Run chezmoi update hourly

[Timer]
OnBootSec=10min
OnUnitActiveSec=1h
Persistent=true

[Install]
WantedBy=timers.target
TIMER

  systemctl --user daemon-reload
  systemctl --user enable --now chezmoi-update.timer
  echo "✅ chezmoi-update.timer enabled"
else
  echo "⚠️ systemd not found. Please schedule chezmoi update manually."
fi

echo "✅ Chezmoi server setup complete."
