#!/usr/bin/env bash
# log-landscape-exec.sh - Display Landscape execution logs

set -euo pipefail

LOG_DIR="/var/log/landscape"

if [[ -d "$LOG_DIR" ]]; then
  echo "🗒️  Listing files in $LOG_DIR" >&2
  ls -1 "$LOG_DIR" || true
  echo

  if [[ -f "$LOG_DIR/commands.log" ]]; then
    echo "📋 Showing recent commands.log entries:" >&2
    tail -n 20 "$LOG_DIR/commands.log" || true
    echo
  fi

  if [[ -f "$LOG_DIR/client.log" ]]; then
    echo "📋 Showing recent client.log entries:" >&2
    tail -n 20 "$LOG_DIR/client.log" || true
    echo
  fi
else
  echo "⚠️  Landscape log directory not found: $LOG_DIR" >&2
fi

echo "📜 Last 20 journal entries for landscape-client:" >&2
journalctl -u landscape-client -n 20 --no-pager 2>/dev/null || true
