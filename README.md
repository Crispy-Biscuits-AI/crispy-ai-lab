# crispy-ai-lab

`crispy-ai-lab` is a working repository for CrispyBrain, a small self-hosted memory assistant built around n8n workflows, Postgres with `pgvector`, and a local Ollama model runtime.

This repo is no longer presented as a general AI lab first. The current product path is much narrower:

- ingest notes or file content into CrispyBrain
- store memory chunks and embeddings in Postgres
- retrieve relevant memory for a question
- generate an answer with Ollama

## Current Core

The current CrispyBrain implementation is centered on:

- exported n8n workflows in [crispybrain/workflows](/Users/elric/repos/crispy-ai-lab/crispybrain/workflows)
- memory schema in [postgres/init/001-crispybrain.sql](/Users/elric/repos/crispy-ai-lab/postgres/init/001-crispybrain.sql)
- sample inbox content in [crispybrain/inbox](/Users/elric/repos/crispy-ai-lab/crispybrain/inbox)
- a minimal deployment path in [docker-compose.minimal.yml](/Users/elric/repos/crispy-ai-lab/docker-compose.minimal.yml)
- operator/setup docs in:
  - [docs/operator-quickstart.md](/Users/elric/repos/crispy-ai-lab/docs/operator-quickstart.md)
  - [docs/setup-minimal.md](/Users/elric/repos/crispy-ai-lab/docs/setup-minimal.md)
  - [docs/workflow-sync.md](/Users/elric/repos/crispy-ai-lab/docs/workflow-sync.md)

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

## Repo Layout

- [crispybrain/workflows](/Users/elric/repos/crispy-ai-lab/crispybrain/workflows): exported active CrispyBrain n8n workflows
- [crispybrain/inbox](/Users/elric/repos/crispy-ai-lab/crispybrain/inbox): sample input files and inbox layout used by the ingest flow
- [postgres/init](/Users/elric/repos/crispy-ai-lab/postgres/init): SQL schema for memory storage
- [docs](/Users/elric/repos/crispy-ai-lab/docs): repo audit, minimum-stack notes, cleanup notes, and deployment explanation
- [optional](/Users/elric/repos/crispy-ai-lab/optional): non-core configs kept for reference
- [archive](/Users/elric/repos/crispy-ai-lab/archive): experimental or legacy artifacts moved out of the main story

## Full Stack vs Minimum Stack

- [docker-compose.minimal.yml](/Users/elric/repos/crispy-ai-lab/docker-compose.minimal.yml) is the recommended starting point for consulting, explanation, and future client deployment work.
- [docker-compose.yml](/Users/elric/repos/crispy-ai-lab/docker-compose.yml) remains a broader local stack with optional services preserved for compatibility and reference.

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

## What Is Optional or Experimental

The repo still contains older or broader lab-era components, but they are not part of the minimum CrispyBrain story:

- LiteLLM config in [optional/litellm](/Users/elric/repos/crispy-ai-lab/optional/litellm)
- OpenClaw config in [optional/openclaw](/Users/elric/repos/crispy-ai-lab/optional/openclaw)
- older compose experiments in [archive/experiments](/Users/elric/repos/crispy-ai-lab/archive/experiments)
- live n8n cleanup planning in [docs/live-n8n-cleanup-plan.md](/Users/elric/repos/crispy-ai-lab/docs/live-n8n-cleanup-plan.md)

## Important Caveat

The active workflows are now exported into the repo, which is a big improvement over the earlier state. But n8n remains a live editing surface, so the exports can still drift from the runtime if workflows are changed in the UI and not re-exported.

That means this repo is now much more truthful and consultable, but workflow export and sync discipline still matters. A fresh n8n instance will also need the required Postgres credential configured before the imported workflows can run.
