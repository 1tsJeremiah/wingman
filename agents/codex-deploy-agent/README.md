# Codex Deploy Agent

This agent pulls updates from a Git repository and runs a custom deploy script.

## Setup

1. Copy `.env.example` to `.env` and fill in the variables.
2. Ensure `fetch-and-deploy.sh` and `deploy.sh` are executable.
3. Optionally install the systemd service or use a cron job.

### Running Manually

```
./fetch-and-deploy.sh
```

### Systemd Installation

Copy `codex-deploy-agent.service` to `~/.config/systemd/user/` and run:

```
systemctl --user daemon-reload
systemctl --user enable --now codex-deploy-agent.service
```

### Troubleshooting

- Check `logs/` for agent output.
- Verify environment variables are correct.
- Ensure the target directory is writable and contains a Git repo.
