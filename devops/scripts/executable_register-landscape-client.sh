#!/bin/bash
# register-landscape-client.sh - Register this machine with Canonical's Landscape Cloud

set -e

# Load environment variables from repo .env if present
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../../.env"
if [[ -f "$ENV_FILE" ]]; then
  set -a
  . "$ENV_FILE"
  set +a
fi

# Required values
title="${LANDSCAPE_TITLE}"
account="${LANDSCAPE_ACCOUNT}"
reg_key="${LANDSCAPE_REG_KEY}"

if [[ -z "$title" || -z "$account" || -z "$reg_key" ]]; then
  echo "Environment variables LANDSCAPE_TITLE, LANDSCAPE_ACCOUNT, and LANDSCAPE_REG_KEY must be set."
  exit 1
fi

# Check root
if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (sudo)"
  exit 1
fi

# Install the client
apt update
apt install -y landscape-client

# Run landscape-config
landscape-config \
  --computer-title "$title" \
  --account-name "$account" \
  --registration-key "$reg_key" \
  --silent

# Success message
echo "✅ Registered with Landscape Cloud as '$title' under account '$account'."
echo "🔗 Visit: https://landscape.canonical.com/computers/"
