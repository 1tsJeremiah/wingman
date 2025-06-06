# Wingman

Wingman is a collection of scripts and infrastructure code used to automate the Pegasus environment. The repository contains Docker Compose files, shell utilities and GitHub workflows that deploy configuration to the server.

## Quick start

1. Clone the repository and install Docker.
2. Copy `.env` to configure your email and domain prefix.
3. Launch the services with:
   ```bash
   docker compose up -d
   ```
   This starts the Traefik reverse proxy defined in `docker-compose.yml`.

Portainer and Landscape helper scripts can be found in `scripts/` and `devops/scripts/`.
Run `scripts/executable_deploy_edge_agent.sh` to deploy the Portainer Edge Agent and `devops/scripts/executable_register-landscape-client.sh` to register a host with Canonical Landscape.

## CI/CD deployment

The [Wingman CI/CD workflow](.github/workflows/wingman.yml) applies the repository to the remote server through `chezmoi` and triggers deployment scripts:
name: Wingman CI/CD

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up SSH for server access
        uses: webfactory/ssh-agent@v0.5.4
        with:
          ssh-private-key: ${{ secrets.WINGMAN_DEPLOY_KEY }}

      - name: Sync with server chezmoi
        run: |
          ssh -o StrictHostKeyChecking=no wingman@198.96.88.177 "chezmoi apply --verbose"

      - name: Trigger Portainer Agent Deployment
        run: |
          ssh wingman@198.96.88.177 "~/scripts/init_wingman.sh"
When changes are pushed to `main`, GitHub Actions connects via SSH and runs the initialization script on the server.

## Documentation

Further documentation lives in the [`docs/`](docs/index.md) folder. The docs describe Wingman as:
# Wingman Ops Portal

Welcome to **Wingman** – your DevOps automation hub.


### Environment variables

The compose file reads values from `.env`:
```bash
ACME_EMAIL=admin@pegasuswingman.com
TRAEFIK_DOMAIN_PREFIX=333
```
