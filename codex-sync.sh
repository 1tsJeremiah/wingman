#!/usr/bin/env bash
set -euo pipefail

# 📁 Go to your actual repo
cd ~/wingman || { echo "❌ Repo directory not found"; exit 1; }

# 🧠 Config
PATCH_FILE="codex-output.patch"
BRANCH="main"

REPO_URL=$(git config --get remote.origin.url || echo "unknown")
GITHUB_USER=$(basename "$(dirname "$REPO_URL")")
REPO_NAME=$(basename -s .git "$REPO_URL")

echo "📦 Repo: $GITHUB_USER/$REPO_NAME"
echo "📥 Paste Codex patch below. End with Ctrl+D:"
nvim "$PATCH_FILE"

# ✅ Apply patch
echo "📌 Applying patch..."
git am "$PATCH_FILE" || {
  echo "❌ Patch failed to apply. Resolve conflicts or check format."
  exit 1
}

# 🚀 Push to main
echo "🚀 Pushing to origin/$BRANCH"
git push origin "$BRANCH"

# 🛠 Check for gh
if ! command -v gh &>/dev/null; then
  echo "⚠️ GitHub CLI 'gh' not found. Skipping PR."
  exit 0
fi

# 📬 Create PR
echo "🔁 Creating PR (or skipping if already exists)"
gh pr create --base "$BRANCH" --head "$BRANCH" \
  --title "Codex auto-sync" \
  --body "This PR syncs Codex-generated changes from patch file."

echo "✅ Codex patch applied, pushed, and PR created (if necessary)."
