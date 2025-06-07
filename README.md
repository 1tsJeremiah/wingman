# Wingman

<<<<<<< ours
Wingman is a collection of DevOps automation utilities.  It contains
scripts and configuration used to manage the **Pegasus Wingman** server
and related infrastructure.  This repository is kept in sync with the
remote server using [chezmoi](https://www.chezmoi.io/) and is backed by
GitHub Actions for CI/CD.

## Purpose

The repository provides:

- `docker-compose.yml` for running Traefik as a reverse proxy.
- Shell scripts under `devops/` and `scripts/` to deploy tools such as
  Portainer Edge Agent and to register Landscape clients.
- GitHub workflows that apply this configuration automatically on the
  server.

## Running Locally

1. Clone the repository:
   ```bash
   git clone https://github.com/1tsjeremiah/wingman.git
   cd wingman
   ```
2. Create an `.env` file and define values for `ACME_EMAIL` and
   `TRAEFIK_DOMAIN_PREFIX` (see `wingman/dot_env` for example values).
3. Start Traefik and any additional services:
   ```bash
   docker-compose up -d
   ```

## Deploying to a Server

Use the helper scripts inside `devops/scripts`:

- `executable_setup-chezmoi-server.sh` – installs chezmoi on the server
  and configures a timer so the server stays in sync with this
  repository.
- `executable_deploy-landscape-script.sh` – example of deploying a
  Landscape script to registered machines.
- `executable_deploy_edge_agent.sh` – deploys the Portainer Edge Agent
  to your Docker swarm.

Run the scripts by copying them to the target server and executing them.
You can also trigger deployments automatically via the GitHub Actions workflow defined in `.github/workflows/wingman.yml`.
=======
Wingman is a collection of DevOps utilities and scripts used to automate server management tasks.  The repository contains shell scripts, Docker configurations and a small Python test suite.  The project also ships a minimal Node.js environment used mainly for linting and other helper scripts.

## Setup

### Python
1. Create a virtual environment and activate it.
2. Install dependencies (only `pytest` is required at the moment):
   ```bash
   pip install -U pytest
   ```

### Node.js
1. Navigate to the `node` directory.
2. Install packages using `npm`:
   ```bash
   cd node
   npm install
   ```

## Running Tests

Run the Python tests from the repository root with:
```bash
pytest
```

The Node.js workspace has a placeholder `npm test` script:
```bash
cd node
npm test
```

## Documentation

Additional information, including portal links, can be found in [docs/index.md](docs/index.md).
>>>>>>> theirs
