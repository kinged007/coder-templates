# Docker-in-Docker Dev Containers

Provision Docker containers as Coder workspaces with Docker-in-Docker support and optional Dev Containers. This template lets each developer get an isolated, full-featured development environment that can run VS Code, SSH, or any web-based IDE — with or without a Git repository and devcontainer configuration.

## Features

- **Docker-in-Docker** — each workspace runs its own Docker daemon inside a privileged container, so developers can build images, run containers, and use `docker compose` without affecting each other.
- **Optional Git clone + Dev Container** — provide a repository URL during workspace creation and the template will clone it and automatically run `devcontainer up` if a `devcontainer.json` is found. Leave the URL blank to get a plain home directory.
- **Code Server (VS Code in the browser)** — the [code-server](https://registry.coder.com/modules/coder/code-server) module is pre-configured with the Dracula theme. Available immediately in the workspace dashboard.
- **Persistent home volume** — `/home/coder` is backed by a Docker volume that survives workspace restarts.
- **Persistent Docker volume** — `/var/lib/docker` is persisted so devcontainer caches and pulled images are reused across restarts.
- **Startup & shutdown scripts** — Docker is cleaned up on stop (`docker system prune -a -f`) and the environment is initialised on start.
- **Git ready** — `GIT_AUTHOR_NAME` and `GIT_AUTHOR_EMAIL` are set automatically from the Coder user profile.
- **Resource monitoring** — CPU, RAM, disk, and host-level metrics are displayed in the workspace dashboard.

## Configuration Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `docker_socket` | `string` | `""` | (Optional) Docker socket URI. Leave empty to auto-detect. |
| `repo_url` | `string` | `""` | URL of a Git repository to clone. If it contains a `devcontainer.json` (at the root or under `.devcontainer/`), the devcontainer CLI will start it automatically. Leave empty to skip cloning. |

## Modules Included

| Module | Version | Source |
|---|---|---|
| [devcontainers-cli](https://registry.coder.com/modules/coder/devcontainers-cli) | `~> 1.0` | `registry.coder.com/coder/devcontainers-cli/coder` |
| [code-server](https://registry.coder.com/modules/coder/code-server) | `1.5.0` | `registry.coder.com/coder/code-server/coder` |
| [git-clone](https://registry.coder.com/modules/coder/git-clone) | `~> 2.0` | `registry.coder.com/coder/git-clone/coder` |

### code-server

The [code-server module](https://registry.coder.com/modules/coder/code-server) provides VS Code in the browser via the workspace dashboard. It is pinned to version `1.5.0` and pre-configured with the Dracula theme (`dracula-theme.theme-dracula`).

To customise — add more extensions, change the theme, or pin a different version — edit the `module "code-server"` block in `main.tf`. Full configuration options are available at:

- **Registry reference:** https://registry.coder.com/modules/coder/code-server
- **Source:** https://github.com/coder/registry/tree/main/registry/coder/modules/code-server

## How to Use

### 1. Deploy the template

```sh
# From your Coder admin machine
coder templates push docker-devcontainer ./templates/docker-devcontainer
```

### 2. Create a workspace

In the Coder UI, click **Create Workspace**, select the **Docker-in-Docker Dev Containers** template, and optionally provide:

- **Git Repository** — the URL of a repo you want to clone (leave blank for a blank workspace)

Once the workspace is running, you'll see code-server available in the dashboard and can open a terminal or SSH in.

### 3. Bring your own devcontainer

If you provided a repository URL and that repo contains a `.devcontainer/devcontainer.json` or `.devcontainer.json`, the template will automatically run `devcontainer up` inside it. All standard devcontainer features (Docker-in-Docker, language runtimes, extensions, etc.) will be available.

### 4. Workspace lifecycle

- **Start** — Docker daemon is started, any repo is cloned, and the devcontainer is launched.
- **Stop** — unused Docker resources are pruned and the Docker service is stopped.
- **Delete** — the workspace container and both volumes (home + Docker) are destroyed.

## Prerequisites

The VM running Coder must have a running Docker socket and the `coder` user must be in the Docker group:

```sh
sudo adduser coder docker
sudo systemctl restart coder
sudo -u coder docker ps
```

> **Note** — This template is a starting point. Edit `main.tf` to add or remove modules, change the base image, adjust resource limits, or modify startup behaviour.
