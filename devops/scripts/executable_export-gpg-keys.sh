#!/bin/bash
# export-gpg-keys.sh - List and export trusted apt GPG keys for Landscape import

set -e

# Optional: install gnupg if missing
if ! command -v gpg >/dev/null; then
  sudo apt update && sudo apt install -y gnupg
fi

# Create output directory
mkdir -p ~/gpg-export

# Loop through all apt keys and export
apt-key list | grep -E '^pub' | while read -r line; do
  KEY_ID=$(echo "$line" | awk '{print $2}' | cut -d'/' -f2)
  if [[ -n "$KEY_ID" ]]; then
    echo "🔑 Exporting $KEY_ID..."
    apt-key export "$KEY_ID" > "~/gpg-export/$KEY_ID.gpg"
  fi
done

echo "✅ All keys exported to ~/gpg-export/*.gpg"
echo "📥 You can now upload these into Landscape GPG Keys"
