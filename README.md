# coder-templates

Reusable Coder workspace templates and boilerplates.

## What it is

A collection of Terraform-based Coder templates — starting with a Docker-in-Docker devcontainer template that provisions an isolated workspace with its own Docker daemon, optional Git clone, and VS Code in the browser.

## Templates

- `docker-devcontainer` — Docker-in-Docker + optional devcontainer, code-server, persistent home and Docker volumes.

## Install

```sh
# From a Coder admin machine
coder templates push docker-devcontainer ./docker-devcontainer
```

## Usage

Create a workspace from the template in the Coder UI. Optionally provide a Git URL; if the repo contains a `devcontainer.json`, the template runs `devcontainer up` automatically.

## Lint & tests

```sh
terraform fmt -check docker-devcontainer/
terraform validate docker-devcontainer/
```

## License

[MIT](LICENSE)
