#!/usr/bin/env bash
set -euo pipefail

# Deployment script for codex-deploy-agent

# Ensure TARGET_DIR is defined
if [[ -z "${TARGET_DIR:-}" ]]; then
  echo "TARGET_DIR is not set" >&2
  exit 1
fi

# Validate current directory
current_dir="$(pwd)"
if [[ "$current_dir" != "$TARGET_DIR" ]]; then
  echo "Expected to run in $TARGET_DIR but running in $current_dir" >&2
  exit 1
fi

# Idempotent actions, e.g., install dependencies or restart services
# Placeholder for service restart
# Example: systemctl restart my_service.service

# Example: restart Docker container (if applicable)
# docker compose up -d

echo "Deployment completed successfully"
