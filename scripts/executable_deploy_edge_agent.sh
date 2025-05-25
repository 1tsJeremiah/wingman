#!/bin/bash
set -euo pipefail
set +H  # Disable history expansion for zsh

SCRIPT_NAME=$(basename "$0")
AGENT_NAME="portainer_edge_agent"
NETWORK_NAME="portainer_agent_network"
VOLUME_NAME="portainer_agent_data"

echo "[+] Cleaning up previous deployments..."

docker service rm "$AGENT_NAME" 2>/dev/null || true
docker network rm "$NETWORK_NAME" 2>/dev/null || true
docker volume rm "$VOLUME_NAME" 2>/dev/null || true

sleep 2

echo "[+] Creating overlay network..."
docker network create --driver overlay "$NETWORK_NAME"

PORTAINER_EDGE_ID=$(uuidgen)
echo "[+] Generated EDGE_ID: $PORTAINER_EDGE_ID"

read -r -p "[?] Paste your valid Portainer EDGE_KEY: " EDGE_KEY
EDGE_KEY=$(echo "$EDGE_KEY" | tr -d '\r\n')

if [[ -z "$EDGE_KEY" ]]; then
  echo '[!] EDGE_KEY cannot be empty. Aborting.'
  exit 1
fi

echo "[+] Deploying Portainer Edge Agent..."

docker service create \
  --name "$AGENT_NAME" \
  --network "$NETWORK_NAME" \
  --env EDGE=1 \
  --env EDGE_ID="$PORTAINER_EDGE_ID" \
  --env EDGE_KEY="$EDGE_KEY" \
  --env EDGE_INSECURE_POLL=1 \
  --env AGENT_CLUSTER_ADDR="tasks.${AGENT_NAME}" \
  --env EDGE_GROUPS=1 \
  --env PORTAINER_GROUP=1 \
  --env EDGE_DEVICE_NAME="$(hostname)" \
  --constraint 'node.platform.os == linux' \
  --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  --mount type=volume,src="$VOLUME_NAME",dst=/data \
  --mode global \
  portainer/agent:2.27.6

echo "[✔] Deployment submitted. Use 'docker service ps $AGENT_NAME' to verify task status."
