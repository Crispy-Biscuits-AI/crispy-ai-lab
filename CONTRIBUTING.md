# Contributing

Thanks for your interest in improving CrispyBrain.

## Before You Change Anything

Start with:

1. [README.md](README.md)
2. [docs/operator-quickstart.md](docs/operator-quickstart.md)
3. [docs/setup-minimal.md](docs/setup-minimal.md)
4. [docs/workflow-sync.md](docs/workflow-sync.md)

## Contribution Principles

- keep the repo truthful to the current CrispyBrain product path
- prefer small, grounded improvements over speculative architecture changes
- do not add private or client-specific material
- keep the line between core, optional, and archive clear
- do not commit secrets or local `.env` values

## Workflow Changes

If you change workflows in n8n:

- re-export them into `crispybrain/workflows/`
- review the JSON diff before commit
- update docs if setup assumptions changed

## Setup Changes

If you change setup or runtime assumptions:

- update `docker-compose.minimal.yml` if the minimum path changed
- update `.env.example` if required variables changed
- update setup/operator/workflow-sync docs

## Release-Facing Hygiene

Before opening a public-facing change:

- review [docs/release-checklist.md](docs/release-checklist.md)
- review [docs/private-boundary-notes.md](docs/private-boundary-notes.md)
- make sure the repo still reads as a CrispyBrain-first public project
