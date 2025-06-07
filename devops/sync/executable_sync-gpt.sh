#!/bin/bash
<<<<<<< ours
# sync-gpt.sh - Synchronize GPT state directory with GitHub using chezmoi
=======
# sync-gpt.sh - Track and push GPT state directory using chezmoi
>>>>>>> theirs

set -e

STATE_DIR="$HOME/.gptstate"
<<<<<<< ours
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
=======
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

>>>>>>> theirs
