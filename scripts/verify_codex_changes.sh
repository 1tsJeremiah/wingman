#!/bin/bash
set -euo pipefail

# Print the 10 most recently modified files in the repo
echo "[+] 10 most recently modified files:"
find . -path ./.git -prune -o -type f -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -n 10 | cut -d' ' -f2-

echo
if [ -d .git ]; then
  echo "[+] Git status:"
  git status
  echo
  echo "[+] Git diff:"
  git diff
fi

echo
CODEx_SESSIONS_DIR="$HOME/.codex/sessions"
if [ -d "$CODEx_SESSIONS_DIR" ]; then
  latest_session=$(ls -dt "$CODEx_SESSIONS_DIR"/* 2>/dev/null | head -n 1)
  if [ -n "$latest_session" ] && [ -f "$latest_session/transcript.json" ]; then
    echo "[+] Last 5 input prompts from $latest_session/transcript.json:"
    jq -r '.[] | .input // empty' "$latest_session/transcript.json" | tail -n 5
  fi
fi
