#!/bin/bash
# register-landscape-client.sh - Register this machine with Canonical's Landscape Cloud

set -e

# Configurable values
title="pegasus"
account="illthvh4"
reg_key="0PjgUOsvyX4zvxZxdVFBnNrfKyG/tw1B6HB3pSfx"

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
