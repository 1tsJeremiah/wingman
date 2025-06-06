#!/bin/bash
# sync-gpt.sh - Track and push GPT state directory using chezmoi

set -e

STATE_DIR="$HOME/.gptstate"
CHEZ_DIR="$HOME/.local/share/chezmoi"

if [ ! -d "$STATE_DIR" ]; then
  echo "❌ State directory $STATE_DIR not found" >&2
  exit 1
fi

# Ensure chezmoi is installed
if ! command -v chezmoi >/dev/null 2>&1; then
  echo "❌ chezmoi command not found" >&2
  exit 1
fi

cd "$STATE_DIR"

# Track any changes in state directory
chezmoi add .
chezmoi apply

# Commit and push if chezmoi repo has a remote
if git -C "$CHEZ_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  cd "$CHEZ_DIR"
  git add .
  if ! git diff --cached --quiet; then
    git commit -m "🔄 GPT state sync $(date +%F_%H:%M:%S)"
    git push
    echo "✅ GPT state pushed to GitHub"
  else
    echo "✅ No GPT state changes to push"
  fi
else
  echo "⚠️ No Git repository configured for chezmoi state" >&2
fi

