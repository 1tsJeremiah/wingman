# Jenkins Bootstrap for GPT Chats

This guide explains how to persist GPT conversation context using **gptstate** and Jenkins so new sessions can resume from where previous chats ended.

## 1. Initialize `gptstate`

Run the provided script to set up a persistent log directory and push it to your dotfiles repository managed by `chezmoi`:

```bash
./devops/scripts/executable_init-gptstate-sync.sh
```

The script creates `~/.gptstate` with a markdown log (`state.md`) and a JSONL log (`logs/state.jsonl`). Both files are tracked and synced through GitHub.

## 2. Jenkins Pipeline

Create a Jenkinsfile in the repository to automate syncing after each chat or on a schedule:

```groovy
pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Sync GPT State') {
            steps {
                sh './devops/sync/executable_sync-gpt.sh'
            }
        }
    }
}
```

This pipeline checks out the repo and runs the `sync-gpt.sh` script, which commits any new log entries and pushes them to GitHub.

## 3. Starting New Chats

Before beginning a new chat session, pull the latest conversation state:

```bash
chezmoi update --apply
```

or run the sync script directly:

```bash
./devops/sync/executable_sync-gpt.sh
```

Then inspect `~/.gptstate/state.md` or `logs/state.jsonl` to recall the previous context.

---

Using Jenkins to automatically push updates ensures each chat session has access to the most recent GPT logs, providing seamless continuity across conversations.
