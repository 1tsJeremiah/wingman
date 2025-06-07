#!/bin/bash

set -euo pipefail

# --- Setup ---
# Determine repo root relative to this script
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT" || exit 1

echo "🔍 Verifying Codex CLI activity in $(pwd)..."

# --- Step 1: Detect Modified/Created Files ---
echo -e "\n📄 Recently modified files:"
find . -type f -printf "%T@ %p\n" | sort -n | tail -10 | cut -d' ' -f2-

# --- Step 2: Git Status (if repo exists) ---
if [ -d .git ]; then
  echo -e "\n🧾 Git Status:"
  git status

  echo -e "\n🧾 Git Diff (preview of changes):"
  git diff
else
  echo -e "\n⚠️ Not a git repository. Skipping git diff."
fi

# --- Step 3: Codex Session Log Check ---
CODEX_LOG="$HOME/.codex/sessions"
echo -e "\n📜 Checking latest Codex session logs in $CODEX_LOG"
LATEST_SESSION=$(find "$CODEX_LOG" -maxdepth 1 -type d -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -1 | cut -d' ' -f2-)

if [ -d "$LATEST_SESSION" ]; then
  echo -e "\n📘 Found session: $LATEST_SESSION"
  echo "Prompt transcript preview:"
  jq '.[].input' "$LATEST_SESSION/transcript.json" 2>/dev/null | tail -5
else
  echo "⚠️ No session logs found."
fi

# --- Step 4: Optional Live Prompt Back to Codex (if connected) ---
read -r -p $'\n🚀 Test Codex CLI by sending: "summarize what changes you made"\nProceed? [y/N] ' confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
  echo "summarize what changes you made" | codex --full-auto
else
  echo "🛑 Skipping Codex test interaction."
fi

