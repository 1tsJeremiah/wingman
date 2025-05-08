#!/bin/bash
# setup-gpt-sync-timer.sh - Installs systemd user timer to run gpt-sync every 15 minutes

set -e

mkdir -p ~/.config/systemd/user

# Service unit
cat > ~/.config/systemd/user/gpt-sync.service <<SERVICE
[Unit]
Description=Sync GPT state to GitHub using chezmoi

[Service]
Type=oneshot
ExecStart=/usr/local/bin/gpt-sync
SERVICE

# Timer unit
cat > ~/.config/systemd/user/gpt-sync.timer <<TIMER
[Unit]
Description=Run gpt-sync every 15 minutes

[Timer]
OnBootSec=5min
OnUnitActiveSec=15min
Persistent=true

[Install]
WantedBy=timers.target
TIMER

# Enable + start timer
systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now gpt-sync.timer

echo "✅ gpt-sync.timer is enabled. Use: journalctl --user -u gpt-sync.service to view logs."
