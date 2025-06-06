#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Load environment variables
if [[ -f .env ]]; then
  # shellcheck disable=SC1091
  source .env
else
  echo ".env file not found" >&2
  exit 1
fi

# Prepare log file
log_dir="$SCRIPT_DIR/logs"
mkdir -p "$log_dir"
log_file="$log_dir/$(date '+%Y-%m-%d-%H%M').log"
exec > >(tee -a "$log_file") 2>&1

echo "$(date '+%Y-%m-%d %H:%M:%S') Starting fetch and deploy" 

# Ensure required variables
: "${REPO_URL:?REPO_URL is required}" 
: "${TARGET_DIR:?TARGET_DIR is required}" 
GIT_BRANCH="${GIT_BRANCH:-main}"

if [[ ! -d "$TARGET_DIR/.git" ]]; then
  echo "Cloning repository"
  git clone --branch "$GIT_BRANCH" "$REPO_URL" "$TARGET_DIR"
else
  echo "Fetching latest changes"
  git -C "$TARGET_DIR" pull origin "$GIT_BRANCH"
fi

# Run deploy script
(
  cd "$TARGET_DIR"
  TARGET_DIR="$TARGET_DIR" bash "$SCRIPT_DIR/deploy.sh"
)

echo "$(date '+%Y-%m-%d %H:%M:%S') Finished deploy" 
