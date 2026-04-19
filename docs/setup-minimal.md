# Minimal Setup

## What "Minimum Working CrispyBrain" Means

A minimum working CrispyBrain environment can:

- ingest memory content through the CrispyBrain workflows
- store memory rows and embeddings in Postgres
- retrieve relevant memory for a question
- generate an answer with Ollama

It does not require the broader optional lab stack.

## Required Files

- [docker-compose.minimal.yml](/Users/elric/repos/crispy-ai-lab/docker-compose.minimal.yml)
- [postgres/init/001-crispybrain.sql](/Users/elric/repos/crispy-ai-lab/postgres/init/001-crispybrain.sql)
- [crispybrain/workflows](/Users/elric/repos/crispy-ai-lab/crispybrain/workflows)
- [.env.example](/Users/elric/repos/crispy-ai-lab/.env.example)

## Required Environment Variables

Create a local `.env` from `.env.example`:

```sh
cp .env.example .env
```

Current minimum variables:

- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `POSTGRES_DB`

## Start The Minimum Stack

```sh
docker compose -f docker-compose.minimal.yml up -d
```

This starts:

- `postgres`
- `n8n`

## Postgres Initialization Assumptions

The Compose stack relies on Docker's standard init behavior for the Postgres image:

- on first start, `postgres/init/001-crispybrain.sql` runs automatically
- it creates the `memories` and `memory_categories` tables
- it enables the `vector` extension

If the Postgres volume already exists, the init SQL will not run again automatically.

## n8n Credentials Required

The current exported workflows expect one n8n credential:

- `Postgres account`

That credential must point at:

- host: `postgres`
- port: `5432`
- database: value of `POSTGRES_DB`
- user: value of `POSTGRES_USER`
- password: value of `POSTGRES_PASSWORD`

## Ollama Host Access Assumptions

The current workflows call Ollama directly at:

- `http://host.docker.internal:11434/api/embed`
- `http://host.docker.internal:11434/api/generate`

Required models:

- `llama3`
- `nomic-embed-text`

The current minimum Compose file assumes Ollama runs on the host, not in Compose.

## Workflow Import

Import the exported workflows from [crispybrain/workflows](/Users/elric/repos/crispy-ai-lab/crispybrain/workflows).

Recommended helper:

```sh
CONFIRM_IMPORT=I_UNDERSTAND scripts/workflows/import-exported-into-docker.sh
```

Manual equivalent:

```sh
docker cp crispybrain/workflows/. ai-n8n:/tmp/crispybrain-workflows
docker exec ai-n8n n8n import:workflow --separate --input=/tmp/crispybrain-workflows
```

Import order does not appear strict for the current exported set, but import the whole directory before activation.

## Inbox Path

The minimum Compose file mounts:

- local repo path: `./crispybrain/inbox`
- inside n8n container: `/home/node/.n8n-files/crispybrain/inbox`

This supports the current watch/ingest mental model:

- sample content lives in the repo
- watch-style workflows can infer `project_slug` from inbox subdirectories

## Practical Bring-Up Sequence

1. copy `.env.example` to `.env`
2. ensure Ollama is running on the host
3. ensure Ollama has `llama3` and `nomic-embed-text`
4. start `docker-compose.minimal.yml`
5. import the exported workflows
6. create the `Postgres account` credential in n8n
7. activate the imported CrispyBrain workflows
8. test ingest and assistant behavior
