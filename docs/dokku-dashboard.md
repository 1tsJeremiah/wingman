# Dokku Dashboard Setup

This repository includes a helper script to install the
[`dokku-dashboard`](https://github.com/dokku/dokku-dashboard.git) plugin and
expose it through Traefik.

Run the script on the Dokku host:

```bash
scripts/executable_setup_dokku_dashboard.sh
```

The script installs the plugin, creates the `dashboard` app and configures
Traefik labels so the dashboard is available at:

```
https://dashboard.${TRAEFIK_DOMAIN_PREFIX}.pegasuswingman.com
```

A Let\'s Encrypt certificate is requested automatically.
