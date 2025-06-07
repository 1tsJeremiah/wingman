#!/bin/bash
set -e

echo "🔍 Verifying cloudflared setup..."

if ! docker ps --format '{{.Names}}' | grep -q '^cloudflared$'; then
  echo "❌ cloudflared container not running!"
  exit 1
fi

if ! docker exec cloudflared ls /etc/cloudflared | grep -q '\.json$'; then
  echo "❌ cloudflared missing tunnel credentials in /etc/cloudflared!"
  exit 1
fi

if ! docker inspect cloudflared | grep -q 'tunnel run'; then
  echo "❌ cloudflared not launched with 'tunnel run <name>'"
  exit 1
fi

echo "✅ cloudflared is running with proper tunnel config"

echo "🔍 Verifying traefik setup..."

if ! docker ps --format '{{.Names}}' | grep -q '^traefik$'; then
  echo "❌ traefik container not running!"
  exit 1
fi

traefik_cmd=$(docker inspect traefik --format '{{json .Config.Cmd}}' | jq -r '.[]')
if ! echo "$traefik_cmd" | grep -q 'entrypoints.websecure.address'; then
  echo "❌ traefik not configured with websecure entrypoint"
  exit 1
fi

echo "✅ traefik entrypoints and config validated"
