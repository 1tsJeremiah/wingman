#!/usr/bin/env bash
set -euo pipefail

# Validate shell scripts in this directory.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
status=0

for script in "$SCRIPT_DIR"/*.sh; do
  # Ensure script has a shebang
  if ! head -n 1 "$script" | grep -q '^#!'; then
    echo "❌ $script is missing a shebang" >&2
    status=1
  fi
done

exit "$status"
