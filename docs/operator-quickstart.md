# Operator Quickstart

Use this when you want the fastest truthful path to the current CrispyBrain demo running locally through the lab.

## 1. Clone Both Repos Side By Side

```sh
git clone <crispybrain-repo-url> crispybrain
git clone <crispy-ai-lab-repo-url> crispy-ai-lab
```

The default demo UI service expects the sibling repo layout above. If your layout is different, set `CRISPYBRAIN_REPO_PATH` in `.env`.

## 2. Configure The Lab Environment

```sh
cd crispy-ai-lab
cp .env.example .env
```

Set at minimum:

- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `POSTGRES_DB`

Optional but useful:

- `OLLAMA_HOST`
- `GENERIC_TIMEZONE`
- `CRISPYBRAIN_REPO_PATH`

## 3. Make Sure Ollama Is Available

The current runtime expects Ollama on the host at `http://host.docker.internal:11434`.

Required models:

- `llama3`
- `nomic-embed-text`

## 4. Start The Demo Runtime

```sh
docker compose up -d postgres n8n crispybrain-demo-ui
```

This is the recommended public walkthrough because it gives you:

- Postgres
- n8n
- the demo UI on `localhost:8787`

If you only want the lab runtime without the demo UI, use `docker-compose.minimal.yml` instead.

## 5. Import The Current Product Workflows

Import the workflow exports from the sibling `crispybrain` repo:

```sh
WORKFLOW_DIR=../crispybrain/workflows \
CONFIRM_IMPORT=I_UNDERSTAND \
scripts/workflows/import-exported-into-docker.sh
```

This imports the current public demo workflow set, including `assistant` and `crispybrain-demo`.

## 6. Configure n8n

Create an n8n credential named `Postgres account` pointing at:

- host `postgres`
- port `5432`
- database from `.env`
- user from `.env`
- password from `.env`

## 7. Activate The Demo Path

In n8n, activate:

- `assistant`
- `crispybrain-demo`

If you import additional workflows from the sibling repo, activate the rest of the current public chain as needed.

## 8. Verify Success

Open:

```text
http://localhost:8787
```

Use:

- project slug: `alpha`
- question: `How am I planning to build CrispyBrain?`

You are in a good state when:

- the demo page loads
- `POST /api/demo/ask` returns JSON
- the answer includes grounded source rows

## 9. Keep It In Sync

If you edit workflows live in n8n and want to re-export them into a repo checkout:

```sh
OUT_DIR=../crispybrain/workflows scripts/workflows/export-active-from-docker.sh
```
