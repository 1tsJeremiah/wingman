#!/bin/bash
set -e
CONF_FILE="/etc/landscape/client.conf"

if grep -q "include-script-plugin" "$CONF_FILE"; then
  echo "✅ Script plugin already configured."
else
  echo "🛠 Enabling script plugin..."
  echo -e "\n[client]\ninclude-script-plugin = true" | sudo tee -a "$CONF_FILE" > /dev/null
fi

echo "🔄 Restarting landscape-client..."
sudo systemctl restart landscape-client
sleep 2
systemctl is-active --quiet landscape-client && echo "✅ landscape-client is running." || echo "❌ landscape-client failed to start."
echo "📡 Script execution support enabled."
