# Operator Quickstart

## 1. Configure Environment

```sh
cp .env.example .env
```

Set:

- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `POSTGRES_DB`

## 2. Make Sure Ollama Is Available

The current workflows expect Ollama on the host at `http://host.docker.internal:11434`.

Required models:

- `llama3`
- `nomic-embed-text`

## 3. Start The Minimum Stack

```sh
docker compose -f docker-compose.minimal.yml up -d
```

## 4. Import The Workflows

```sh
CONFIRM_IMPORT=I_UNDERSTAND scripts/workflows/import-exported-into-docker.sh
```

## 5. Configure n8n

Create an n8n credential named `Postgres account` pointing at:

- host `postgres`
- port `5432`
- database from `.env`
- user from `.env`
- password from `.env`

## 6. Activate And Check

Activate the exported CrispyBrain workflows in n8n.

You should have 7 core workflows:

- `crispybrain-auto-ingest-watch`
- `crispybrain-ingest`
- `crispybrain-build-context`
- `crispybrain-answer-from-memory`
- `crispybrain-assistant`
- `crispybrain-project-memory`
- `crispybrain-validation-and-errors`

## 7. Basic Working Checks

- `docker compose -f docker-compose.minimal.yml ps` shows `postgres` and `n8n` up
- Ollama responds on the host
- n8n can reach the `Postgres account` credential
- importing a note via `crispybrain-ingest` succeeds
- asking a question via `crispybrain-assistant` returns a response

## 8. Keep It In Sync

After any workflow edits in n8n:

```sh
scripts/workflows/export-active-from-docker.sh
```
