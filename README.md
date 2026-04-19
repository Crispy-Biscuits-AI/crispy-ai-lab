# Crispy AI Lab

`crispy-ai-lab` is the local runtime and infrastructure repo for CrispyBrain.

It is the place where you run the Docker-based lab stack: Postgres with `pgvector`, `n8n`, and the `crispybrain-demo-ui` service that serves the local demo on `http://localhost:8787`.

This repo is intentionally not the product surface repo. The current public demo UI, demo workflow, and product-facing docs live in the sibling `crispybrain` repo.

## Current State

- early, real, build-in-public local runtime
- self-hosted and local-first
- good for running the demo and inspecting the stack
- not a turnkey production deployment
- not a managed SaaS or one-command installer

## How It Fits With `crispybrain`

- `crispybrain`: product/demo repo, UI assets, demo workflow, public-facing docs
- `crispy-ai-lab`: runtime repo, Docker Compose stack, local services, and lab-oriented helper scripts

Clone both repos as sibling directories if you want the default demo path to work without overrides.

## What The Lab Runs

Main services in the default stack:

- `postgres`: memory store with `pgvector`
- `n8n`: workflow runtime, pinned here to `2.16.1`
- `crispybrain-demo-ui`: demo UI built from the sibling `crispybrain` repo and served on port `8787`

Host-side dependency:

- Ollama running on the host at `http://host.docker.internal:11434`

Required Ollama models for the current demo path:

- `llama3`
- `nomic-embed-text`

## Prerequisites

- Docker Desktop with Docker Compose support
- Docker Desktop for macOS `4.69.0` is the tested target for this pass
- Ollama running on the host
- a sibling checkout of `crispybrain`, or an override via `CRISPYBRAIN_REPO_PATH`

## Quickstart

This is the most honest current path to the public demo:

1. Clone both repos side by side.

```bash
git clone <crispybrain-repo-url> crispybrain
git clone <crispy-ai-lab-repo-url> crispy-ai-lab
```

2. Configure the lab environment.

```bash
cd crispy-ai-lab
cp .env.example .env
```

3. Start the runtime stack.

```bash
docker compose up -d postgres n8n crispybrain-demo-ui
```

4. Import the current workflow exports from the sibling `crispybrain` repo.

```bash
WORKFLOW_DIR=../crispybrain/workflows \
CONFIRM_IMPORT=I_UNDERSTAND \
scripts/workflows/import-exported-into-docker.sh
```

5. In n8n, create a Postgres credential named `Postgres account` using the values from `.env`.

6. Activate the imported `assistant` and `crispybrain-demo` workflows.

7. Open the demo.

```text
http://localhost:8787
```

8. Ask the recommended demo question with project slug `alpha`:

```text
How am I planning to build CrispyBrain?
```

Success currently looks like:

- the page loads on `localhost:8787`
- `POST /api/demo/ask` returns JSON
- the demo UI shows an answer plus retrieved sources
- the request path reaches `crispybrain-demo`, which forwards into `assistant`

## URLs

- Demo UI: `http://localhost:8787`
- n8n: `http://localhost:5678`
- Postgres: `localhost:5432`

## Manual Steps And Honest Assumptions

This repo is public-ready, not fully turnkey. The following still need a real operator:

- copy `.env.example` to `.env`
- keep Ollama running on the host
- import the workflow JSON manually or via the helper script
- create the `Postgres account` credential in n8n
- activate workflows in n8n after import
- keep workflow exports in sync if you edit them live in the n8n UI

The lab also assumes:

- the current demo UI build context points at `../crispybrain` unless you override `CRISPYBRAIN_REPO_PATH`
- the first-run Postgres init SQL only applies when the Postgres volume is new
- some underlying runtime names and stored data may still carry earlier `openbrain-*` compatibility labels

## Minimal Stack

If you only want the lab runtime without the demo UI, use:

```bash
docker compose -f docker-compose.minimal.yml up -d postgres n8n
```

That path is useful for workflow work, but the main public demo walkthrough uses the default `docker-compose.yml` stack because it includes `crispybrain-demo-ui`.

## Repo Layout

- `docker-compose.yml`: default local demo/runtime stack
- `docker-compose.minimal.yml`: smaller runtime without the demo UI
- `postgres/init/`: first-run Postgres schema bootstrap
- `scripts/workflows/`: import/export helpers for the local n8n container
- `docs/`: setup, scope, workflow-sync, and public-readiness notes
- `crispybrain/`: older lab-side workflow exports and sample inbox content kept for reference
- `optional/`: non-core configs intentionally outside the main startup path
- `archive/`: older experiments and legacy material

## Troubleshooting Basics

- Check service state with `docker compose ps`.
- Tail logs with `docker compose logs -f n8n crispybrain-demo-ui`.
- If the demo UI loads but answers fail, verify Ollama is running and reachable from the `n8n` container.
- If the workflow import succeeds but the demo webhook is missing, confirm `crispybrain-demo` is imported and activated.
- If Postgres schema objects are missing on a reused volume, recreate the Postgres volume intentionally before retrying first-run setup.

## More Docs

- [Operator Quickstart](docs/operator-quickstart.md)
- [Minimal Setup](docs/setup-minimal.md)
- [Workflow Sync](docs/workflow-sync.md)
- [Public Scope](docs/public-scope.md)
- [Private Boundary Notes](docs/private-boundary-notes.md)
- [Legacy Naming Debt](docs/legacy-naming-debt.md)
- [Contributing](CONTRIBUTING.md)
- [Security](SECURITY.md)

## License

[MIT](LICENSE)
