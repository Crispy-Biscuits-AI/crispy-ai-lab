# crispy-ai-lab

`crispy-ai-lab` is the public-facing working repository for CrispyBrain, a small self-hosted memory assistant built around n8n workflows, Postgres with `pgvector`, and a local Ollama model runtime.

The current product path is intentionally narrow:

- ingest notes or file content into CrispyBrain
- store memory chunks and embeddings in Postgres
- retrieve relevant memory for a question
- generate an answer with Ollama

## Current Core

The current CrispyBrain implementation is centered on:

- exported n8n workflows in [crispybrain/workflows](crispybrain/workflows)
- memory schema in [postgres/init/001-crispybrain.sql](postgres/init/001-crispybrain.sql)
- sample inbox content in [crispybrain/inbox](crispybrain/inbox)
- a minimal deployment path in [docker-compose.minimal.yml](docker-compose.minimal.yml)
- operator/setup docs in:
  - [operator quickstart](docs/operator-quickstart.md)
  - [minimal setup](docs/setup-minimal.md)
  - [workflow sync](docs/workflow-sync.md)
  - [public scope](docs/public-scope.md)

The exported workflow set currently includes:

- `crispybrain-auto-ingest-watch`
- `crispybrain-ingest`
- `crispybrain-build-context`
- `crispybrain-answer-from-memory`
- `crispybrain-assistant`
- `crispybrain-project-memory`
- `crispybrain-validation-and-errors`

## Minimum Deployment Shape

The smallest current runtime story is:

- `n8n`
- `Postgres` with `pgvector`
- `Ollama`

Ollama is currently expected to run on the host machine, not inside Compose. The active workflows call:

- `http://host.docker.internal:11434/api/embed`
- `http://host.docker.internal:11434/api/generate`

To start the minimum stack:

```sh
docker compose -f docker-compose.minimal.yml up -d
```

After import, the workflows still need an n8n Postgres credential named `Postgres account` or an equivalent remapped credential in the target instance.

## Start Here

If you are new to the repo, use this order:

1. [Operator Quickstart](docs/operator-quickstart.md)
2. [Minimal Setup](docs/setup-minimal.md)
3. [Workflow Sync](docs/workflow-sync.md)
4. [Public Scope](docs/public-scope.md)

## Repo Layout

- [crispybrain/workflows](crispybrain/workflows): exported active CrispyBrain n8n workflows
- [crispybrain/inbox](crispybrain/inbox): sample input files and inbox layout used by the ingest flow
- [postgres/init](postgres/init): SQL schema for memory storage
- [docs](docs): repo audit, minimum-stack notes, cleanup notes, and deployment explanation
- [optional](optional): non-core configs kept for reference
- [archive](archive): experimental or legacy artifacts moved out of the main story

## Full Stack vs Minimum Stack

- [docker-compose.minimal.yml](docker-compose.minimal.yml) is the recommended starting point for consulting, explanation, and future client deployment work.
- [docker-compose.yml](docker-compose.yml) remains a broader local stack with optional services preserved for compatibility and reference.

## Core vs Optional vs Archive

- Core:
  - `crispybrain/workflows`
  - `crispybrain/inbox`
  - `postgres/init/001-crispybrain.sql`
  - `docker-compose.minimal.yml`
- Optional:
  - `optional/`
  - broader integrations preserved in `docker-compose.yml`
- Archived:
  - `archive/`
  - no longer part of the default CrispyBrain path

## Public Scope

This public repo is about the CrispyBrain core:

- workflow-driven memory ingest
- memory retrieval from Postgres
- answer generation with Ollama

Out of scope for the public core story:

- CMS implementation details
- client-specific integrations
- internal experiments that are not documented as current CrispyBrain behavior

See [docs/public-scope.md](docs/public-scope.md) and [docs/private-boundary-notes.md](docs/private-boundary-notes.md).

## What Is Optional or Experimental

The repo still contains older or broader lab-era components, but they are not part of the minimum CrispyBrain story:

- LiteLLM config in [optional/litellm](optional/litellm)
- OpenClaw config in [optional/openclaw](optional/openclaw)
- older compose experiments in [archive/experiments](archive/experiments)
- live n8n cleanup planning in [docs/live-n8n-cleanup-plan.md](docs/live-n8n-cleanup-plan.md)

## Open Source Readiness

This repo is being prepared for public release as a CrispyBrain-first project.

Useful release-facing docs:

- [Open Source Readiness Audit](docs/open-source-readiness-audit.md)
- [Release Checklist](docs/release-checklist.md)
- [Public Release Recommendation](docs/public-release-recommendation.md)
- [License Decision Needed](docs/license-decision-needed.md)
- [Contributing](CONTRIBUTING.md)

## Important Caveat

The active workflows are now exported into the repo, which is a big improvement over the earlier state. But n8n remains a live editing surface, so the exports can still drift from the runtime if workflows are changed in the UI and not re-exported.

That means this repo is now much more truthful and consultable, but workflow export and sync discipline still matters. A fresh n8n instance will also need the required Postgres credential configured before the imported workflows can run.
