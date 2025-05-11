  #!/bin/bash
# deploy-landscape-script.sh - Create and execute a script on a registered Landscape client via API

set -e

# Config
TITLE="Run system update"
BODY="apt update && apt upgrade -y"
TARGET_TITLE="pegasus"

# Create script via Landscape API
SCRIPT_ID=$(landscape-api create-script \
  --json \
  --title "$TITLE" \
  --body "$BODY" \
  --run-as-root true \
  | jq -r '.id')

if [[ -z "$SCRIPT_ID" || "$SCRIPT_ID" == "null" ]]; then
  echo "❌ Failed to create script."
  exit 1
fi

echo "✅ Script created with ID: $SCRIPT_ID"

# Fetch computer ID by title
COMPUTER_ID=$(landscape-api get-computers --json | jq -r ".[] | select(.title==\"$TARGET_TITLE\") | .id")

if [[ -z "$COMPUTER_ID" || "$COMPUTER_ID" == "null" ]]; then
  echo "❌ Could not find computer titled '$TARGET_TITLE'."
  exit 1
fi

# Execute script
landscape-api execute-script \
  --script-id "$SCRIPT_ID" \
  --computer-ids "$COMPUTER_ID"

echo "🚀 Script '$TITLE' executed on '$TARGET_TITLE' ($COMPUTER_ID)"

