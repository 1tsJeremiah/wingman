#!/bin/bash
# sync-gpt.sh - Synchronize GPT state directory with GitHub using chezmoi

set -e

STATE_DIR="$HOME/.gptstate"
CHEZMOI_DIR="$HOME/.local/share/chezmoi"

# Ensure state directory exists
if [[ ! -d "$STATE_DIR" ]]; then
  echo "❌ GPT state directory not found: $STATE_DIR" >&2
  exit 1
fi

# Stage changes in the GPT state directory
chezmoi add "$STATE_DIR"
chezmoi apply

cd "$CHEZMOI_DIR"

if git remote get-url origin >/dev/null 2>&1; then
  if ! git diff --quiet; then
    git add .
    git commit -m '🔄 GPT state sync'
    git push
    echo "✅ GPT state synced to GitHub"
  else
    echo "ℹ️ No GPT state changes to sync"
  fi
else
  echo "⚠️ No Git remote configured for chezmoi repo"
fi
