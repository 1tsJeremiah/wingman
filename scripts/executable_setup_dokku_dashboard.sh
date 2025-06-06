#!/bin/bash
# setup-dokku-dashboard.sh - Install dokku-dashboard plugin and expose behind Traefik

set -euo pipefail

APP="dashboard"
# use the maintained dokku-dashboard fork
PLUGIN_URL="https://github.com/lohanbodevan/dokku-dashboard.git"
DASHBOARD_DOMAIN="dashboard.${TRAEFIK_DOMAIN_PREFIX}.pegasuswingman.com"

# install plugin if missing
if ! dokku plugin:list | grep -q dokku-dashboard; then
  echo "[+] Installing dokku-dashboard plugin"
  dokku plugin:install "$PLUGIN_URL"
else
  echo "[+] dokku-dashboard plugin already installed"
fi

# create app if needed
if ! dokku apps:exists "$APP"; then
  dokku apps:create "$APP"
fi

# deploy the dashboard using the plugin
if ! dokku ps:report "$APP" >/dev/null 2>&1; then
  dokku dashboard:deploy "$APP"
fi

dokku domains:set "$APP" "$DASHBOARD_DOMAIN"

# ensure Traefik routing labels are present
cat <<LABELS | dokku docker-options:add "$APP" deploy
--label traefik.enable=true
--label traefik.http.routers.${APP}.rule=Host(\"$DASHBOARD_DOMAIN\")
--label traefik.http.routers.${APP}.entrypoints=web,websecure
--label traefik.http.routers.${APP}.tls.certresolver=myresolver
--health-cmd "curl -f http://localhost:5000/health || exit 1"
--health-interval 30s
--health-retries 3
--health-start-period 10s
--health-timeout 3s
LABELS

dokku letsencrypt:enable "$APP"

echo "✅ Dokku dashboard available at https://$DASHBOARD_DOMAIN"
