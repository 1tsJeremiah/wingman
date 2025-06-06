#!/bin/bash
# sync-gpt.sh - Sync ~/.gptstate to GitHub using chezmoi

set -e

STATE_DIR="$HOME/.gptstate"
CHEZMOI_DIR="$HOME/.local/share/chezmoi"

if [[ ! -d "$STATE_DIR" ]]; then
  echo "⚠️ GPT state directory not found: $STATE_DIR"
  exit 1
fi

# Track any changes in the GPT state directory
chezmoi add "$STATE_DIR" >/dev/null
chezmoi apply >/dev/null

cd "$CHEZMOI_DIR"
if git remote get-url origin >/dev/null 2>&1; then
  git add -A
  if git diff --cached --quiet; then
    echo "✅ No GPT state changes to sync"
  else
    git commit -m '🔄 Sync GPT state'
    git push
    echo "🚀 GPT state pushed to GitHub"
  fi
else
  echo "⚠️ GitHub remote not configured for chezmoi"
fi
