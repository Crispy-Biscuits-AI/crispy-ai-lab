# Repo Audit

## Executive Summary

`crispy-ai-lab` is currently more of an infrastructure shell around a live n8n system than a self-contained product repository. The real CrispyBrain behavior is happening in active n8n workflows stored in Postgres, while the Git-tracked repo mostly contains Docker wiring, a database schema, sample inbox files, and now exported workflow snapshots.

The strongest current product path is:

1. `crispybrain` content enters through n8n webhooks or the inbox mount.
2. n8n calls Ollama directly for embeddings and generation.
3. n8n stores and retrieves memory data from Postgres with `pgvector`.
4. the active CrispyBrain experience is exposed through n8n webhooks such as `crispybrain-assistant`.

That means the current functional core is smaller than the Compose stack suggests. Several services look like lab-era additions rather than essential CrispyBrain runtime components.

## Current Repo Shape

### Top-level tracked files and directories

| Item | What it is | Classification |
| --- | --- | --- |
| `README.md` | High-level repo description | REQUIRED NOW |
| `docker-compose.yml` | Main local stack definition | REQUIRED NOW |
| `docker-compose.minimal.yml` | Smaller current deploy path for CrispyBrain | REQUIRED NOW |
| `postgres/init/001-crispybrain.sql` | CrispyBrain memory schema with `pgvector` | REQUIRED NOW |
| `crispybrain/` | Workflow exports plus seed data and inbox examples | REQUIRED NOW, but mixed with experimental fixtures |
| `optional/` | Quarantined non-core configuration | KEEP FOR LATER |
| `archive/` | Quarantined experimental / legacy material | KEEP FOR LATER |

### Non-tracked / local-only items visible in the repo root

| Item | What it suggests | Classification |
| --- | --- | --- |
| `.env` | Local secrets/config for Docker runs | REQUIRED NOW for local runtime, but not a clean client artifact |
| `.DS_Store`, `crispybrain/.DS_Store` | Finder noise / root clutter | REMOVE CANDIDATE |

## CrispyBrain Core

## What CrispyBrain's current functional core appears to be

Evidence from the live n8n/Postgres state shows 7 active workflows:

- `crispybrain-assistant`
- `crispybrain-build-context`
- `crispybrain-answer-from-memory`
- `crispybrain-ingest`
- `crispybrain-auto-ingest-watch`
- `crispybrain-project-memory`
- `crispybrain-validation-and-errors`

These active workflows use only:

- `n8n-nodes-base.webhook`
- `n8n-nodes-base.code`
- `n8n-nodes-base.httpRequest`
- `n8n-nodes-base.postgres`
- `n8n-nodes-base.if`
- `n8n-nodes-base.respondToWebhook`

The live workflows directly call:

- `http://host.docker.internal:11434/api/embed`
- `http://host.docker.internal:11434/api/generate`
- internal n8n webhook URLs on `127.0.0.1:5678`

The only stored n8n credential currently present is:

- `Postgres account` of type `postgres`

The active workflow chain therefore looks like this:

- `crispybrain-auto-ingest-watch` normalizes file/watch payloads and forwards to `crispybrain-ingest`
- `crispybrain-ingest` gets embeddings from Ollama and stores chunks in Postgres
- `crispybrain-build-context` gets an embedding from Ollama and retrieves matching memories from Postgres
- `crispybrain-answer-from-memory` sends a prompt to Ollama for generation
- `crispybrain-assistant` orchestrates session turns, context building, and answer generation

This is the current product center of gravity.

## Minimum current architectural truth

The repo suggests a broad AI lab, but the live evidence points to a much smaller working core:

- n8n as the application runtime
- Postgres with `pgvector` as the memory store
- Ollama as the model provider for both embeddings and generation
- `crispybrain/` inbox content as input material for ingest experiments

## Service-by-Service Assessment

| Service / Component | Evidence | Assessment | Classification |
| --- | --- | --- | --- |
| `n8n` | All active CrispyBrain workflows live there | This is the application runtime today | REQUIRED NOW |
| `postgres` / `pgvector` | Active workflows use Postgres; schema defines `memories` and categories | Core memory store | REQUIRED NOW |
| `Ollama` on host | Active workflows call Ollama directly for `/api/embed` and `/api/generate` | Core model runtime | REQUIRED NOW |
| `crispybrain/` inbox mount | n8n mounts the repo inbox into its working file area | Supports current ingest/watch story | REQUIRED NOW |
| `litellm` | No active workflow references LiteLLM; config only routes a single Ollama model | Adds an extra hop without evidence of current CrispyBrain value | REMOVE CANDIDATE |
| `open-webui` | Not referenced by active workflows; depends on LiteLLM | Separate UI/demo surface, not the CrispyBrain core | KEEP FOR LATER |
| `qdrant` | No active workflow references it; runtime collections are empty | Present in stack, but unused | REMOVE CANDIDATE |
| `adminer` | Manual DB inspection only | Helpful for local debugging, not client minimum | KEEP FOR LATER |
| `openclaw` | Not referenced by active workflows; separate config and browser dependency | Experimental side path | ARCHIVE / EXPERIMENTAL |
| `browser` | Only supports OpenClaw | No direct CrispyBrain role | ARCHIVE / EXPERIMENTAL |
| `mock.yml` stack | Alternate stack with Redis, stale `ai-lab` naming, and divergent architecture | Old prototype path | ARCHIVE / EXPERIMENTAL |

## Root Clutter Assessment

### Clear root clutter or cleanup pressure

- `.DS_Store` files are pure noise.
- The broader full-stack Compose file still contains optional lab-era services.
- Some non-core configs have now been quarantined into `optional/`.
- Some repetitive test artifacts have now been quarantined into `archive/`.

### Mixed-value content inside `crispybrain/`

| Item | Assessment | Classification |
| --- | --- | --- |
| `crispybrain/inbox/crispybrain-seed-memories.txt` | Useful as a seed/example for the memory system | KEEP FOR LATER |
| `crispybrain/inbox/alpha/watch-test.txt` | Useful as a single example of the watch flow | KEEP FOR LATER |
| `crispybrain/inbox/alpha/final-watch-test*.txt` | Repetitive test artifacts, not customer-facing product material | ARCHIVE / EXPERIMENTAL |

## Architectural Duplication Assessment

### 1. Repo says "AI lab"; runtime says "CrispyBrain memory workflows"

The README and Compose stack frame the repo as a multi-service AI lab. The actual active behavior is much narrower and more product-like: CrispyBrain memory ingestion, retrieval, and answer generation through n8n plus Ollama plus Postgres.

### 2. LiteLLM duplicates capability already present in Ollama

Repo evidence:

- `litellm-config.yaml` defines one model route only: `ollama/llama3:latest`
- active n8n workflows do not reference LiteLLM
- active n8n workflows call Ollama directly
- the only current LiteLLM consumer in tracked config is `open-webui`

Conclusion:

- LiteLLM currently acts as a wrapper around a single Ollama route
- it is not part of the live CrispyBrain workflow path
- it increases moving parts for little demonstrated benefit

### 3. Qdrant duplicates vector-store responsibility already handled by Postgres + pgvector

Repo/runtime evidence:

- Postgres schema includes `embedding vector(1536)`
- active workflows retrieve and store memory data in Postgres
- Qdrant has zero collections
- active workflows do not reference Qdrant

Conclusion:

- Qdrant is currently redundant

### 4. Product logic is outside source control

This was the biggest structural issue in the repo.

Evidence:

- 7 active workflows define the real CrispyBrain behavior
- 89 inactive workflows remain in the database as historical clutter
- the repo now stores exported snapshots in `crispybrain/workflows`, but runtime can still drift from those exports

Conclusion:

- the repo is closer to a clean deployable product artifact than before
- but it is still partly dependent on live n8n state and workflow export discipline

## Risks and Uncertainties

### Confirmed risks

- The working product logic is not versioned in Git.
- The Compose file still contains non-core services that complicate explanation and deployment.
- Some runtime/state names are stale (`openbrain_chat_turns` in workflow SQL) even though the product direction is now CrispyBrain.
- `docker-compose.yml` uses a hardcoded absolute host path for the inbox mount, which is a poor client deployment story.

### Uncertainties requiring a human decision

| Item | Why it is unclear | Classification |
| --- | --- | --- |
| `open-webui` | It is not part of the active CrispyBrain workflow path, but it may still be useful as a demo or admin chat surface | UNCLEAR / NEEDS HUMAN DECISION |
| `adminer` | Not part of client runtime, but convenient for consulting/debugging | UNCLEAR / NEEDS HUMAN DECISION |
| seed/test inbox files | At least one example file is useful; the right number to keep is a product-positioning decision | UNCLEAR / NEEDS HUMAN DECISION |

## Recommended Target Shape

## Smallest clean client-deployable shape

At minimum, the future client-ready repo should center on:

- exported and version-controlled CrispyBrain n8n workflows
- a slim Compose stack for:
  - `n8n`
  - `postgres` with `pgvector`
- clear expectation that Ollama is available, or a documented replacement model endpoint
- one sample `crispybrain/` inbox path or example payload
- concise docs focused on what CrispyBrain does, not on the whole lab

## What should stay

- `docker-compose.yml`, but likely slimmed later
- `postgres/init/001-crispybrain.sql`
- a cleaned `crispybrain/` example payload set
- `crispybrain/workflows/`
- a rewritten README and deployment docs
- the active CrispyBrain workflows, once exported into the repo

## What should move out of the default story

- LiteLLM
- Qdrant
- Open WebUI
- OpenClaw
- browser
- Adminer
- `mock.yml`
- repetitive watch test artifacts

## Recommended cleanup direction

1. Keep the active workflow exports in sync with n8n runtime edits.
2. Prefer `docker-compose.minimal.yml` as the primary deploy story.
3. Move more non-core services out of the default Compose path in a later pass.
4. Remove duplicate vector/model-routing layers that are not earning their complexity.
5. Reduce sample/test clutter in `crispybrain/inbox/alpha/` further if desired.
6. Continue tightening docs around CrispyBrain rather than the old AI-lab framing.
