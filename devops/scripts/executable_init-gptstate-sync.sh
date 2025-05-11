#!/bin/bash
# init-gptstate-sync.sh - Initialize a persistent GPT log state directory, track with chezmoi, push to GitHub

set -e

STATE_DIR="$HOME/.gptstate"
LOG_FILE="$STATE_DIR/state.md"

# Create GPT state directory
mkdir -p "$STATE_DIR/logs"
echo "📁 Created: $STATE_DIR"

# Write initial log file if not exists
if [[ ! -f "$LOG_FILE" ]]; then
  cat <<EOFLOG > "$LOG_FILE"
# GPT Ops Log for Pegasus

## ✅ $(date +%F)

- Initialized GPT state tracking system
- Dotfile managed by chezmoi
- Ready for synchronization with GitHub and GPT memory

## 🔗 Related Files

- (To be populated)

EOFLOG
  echo "📝 Initialized: $LOG_FILE"
fi

# Track and apply via chezmoi
chezmoi add "$LOG_FILE"
chezmoi add "$STATE_DIR/logs"
chezmoi apply

# Git sync if repo exists
cd ~/.local/share/chezmoi
if git remote get-url origin >/dev/null 2>&1; then
  git add .
  git commit -m '🔄 GPT state initialized via script'
  git push
  echo "🚀 GPT state pushed to GitHub"
else
  echo "⚠️ GitHub remote not found. Run chezmoi git init + remote add to enable push."
fi

echo "✅ GPT state system is ready. Log at: $LOG_FILE"
