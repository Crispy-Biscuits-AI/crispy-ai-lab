# crispy-labs

`crispy-labs` is a small self-hosted AI lab repository centered on a local Docker Compose stack. The current repo is mostly infrastructure and configuration: it wires together PostgreSQL with `pgvector`, Qdrant, LiteLLM, n8n, Open WebUI, OpenClaw, and a small `openbrain` memory schema and seed dataset.

## What's in this repo

- `docker-compose.yml`: the main local stack definition
- `litellm-config.yaml`: LiteLLM model routing config for a local Ollama-backed model
- `openclaw.json`: OpenClaw gateway and model provider configuration
- `postgres/init/001-openbrain.sql`: PostgreSQL schema for the `openbrain` memory store, including `vector` support
- `openbrain/inbox/openbrain-seed-memories.txt`: seed content for local memory-ingestion experiments

## Current status

This repository appears to be an experimental local lab environment rather than a polished application. The checked-in files are enough to describe and start the container stack, but the repo does not yet include broader documentation, automation scripts, or application source code beyond the database initialization and configuration files.

## Getting started

Prerequisites clearly implied by the repository:

- Docker with Compose support
- A local Ollama instance reachable from containers at `http://host.docker.internal:11434`
- A populated `.env` file with the variables referenced by `docker-compose.yml`

The main runnable entrypoint in the repository is:

```sh
docker compose up -d
```

Useful files to inspect before starting:

- `docker-compose.yml`
- `litellm-config.yaml`
- `openclaw.json`
- `postgres/init/001-openbrain.sql`

## Notes

This repository was previously named `ai-lab` and has since been renamed to `crispy-labs`.
