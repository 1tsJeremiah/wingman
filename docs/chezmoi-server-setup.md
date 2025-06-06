# Remote Server Dotfile Sync

This project uses [chezmoi](https://www.chezmoi.io/) to manage dotfiles on the VPS.
The script `executable_setup-chezmoi-server.sh` installs chezmoi, pulls the
repository and configures a systemd timer to keep the server in sync.

## Usage

1. Copy the script to the server and run it:
   ```bash
   bash executable_setup-chezmoi-server.sh
   ```
2. The script installs required packages, initializes or updates the chezmoi
   repository from GitHub and enables a `chezmoi-update.timer` that runs hourly.

Once completed, your server's configuration files will stay up to date with the
GitHub repository automatically.
