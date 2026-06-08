#!/bin/bash
set -e

REPO_URL="${repo_url}"
NEW_BRANCH="${new_branch}"
WORKSPACE_FOLDER="$HOME"

if [ -n "$REPO_URL" ]; then
    FOLDER_NAME=$(basename "$REPO_URL" .git)
    WORKSPACE_FOLDER="$HOME/$FOLDER_NAME"
    echo "Waiting for repository to be cloned into '$FOLDER_NAME'..."
    TIMEOUT=60
    while [ ! -d "$WORKSPACE_FOLDER" ] && [ $TIMEOUT -gt 0 ]; do
        sleep 2
        TIMEOUT=$((TIMEOUT - 2))
    done
    if [ -d "$WORKSPACE_FOLDER" ]; then
        # If a new branch name was provided, checkout or create it
        if [ -n "$NEW_BRANCH" ]; then
            cd "$WORKSPACE_FOLDER"
            echo "Setting up branch '$NEW_BRANCH'..."
            git checkout "$NEW_BRANCH" 2>/dev/null || git checkout -b "$NEW_BRANCH"
            echo "Switched to branch '$NEW_BRANCH'."
        fi

        if [ -f "$WORKSPACE_FOLDER/.devcontainer/devcontainer.json" ]; then
            echo "Devcontainer configuration found at .devcontainer/devcontainer.json. Starting devcontainer..."
            devcontainer up --workspace-folder "$WORKSPACE_FOLDER"
            echo "Devcontainer started successfully."
        elif [ -f "$WORKSPACE_FOLDER/.devcontainer.json" ]; then
            echo "Devcontainer configuration found at .devcontainer.json. Starting devcontainer..."
            devcontainer up --workspace-folder "$WORKSPACE_FOLDER"
            echo "Devcontainer started successfully."
        else
            echo "No devcontainer configuration found in '$FOLDER_NAME'."
        fi
    else
        echo "Repository folder '$FOLDER_NAME' not found after waiting."
    fi
else
    echo "No repository URL provided. Working directory: $HOME"
fi
