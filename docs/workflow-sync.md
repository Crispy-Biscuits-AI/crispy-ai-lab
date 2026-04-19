# Workflow Sync

## Canonical Workflow Location

The canonical exported workflow snapshots live in [crispybrain/workflows](../crispybrain/workflows).

Current exported core:

- `crispybrain-auto-ingest-watch.json`
- `crispybrain-ingest.json`
- `crispybrain-build-context.json`
- `crispybrain-answer-from-memory.json`
- `crispybrain-assistant.json`
- `crispybrain-project-memory.json`
- `crispybrain-validation-and-errors.json`

These files are the repo-side source of truth for the current CrispyBrain workflow layer. The live n8n instance is still editable, so operators must keep exports in sync.

## Export Updated Workflows From n8n

### Recommended local helper

Use [scripts/workflows/export-active-from-docker.sh](../scripts/workflows/export-active-from-docker.sh) when working against the local Docker-based n8n container.

```sh
scripts/workflows/export-active-from-docker.sh
```

Default assumptions:

- the n8n container is named `ai-n8n`
- the repo root is the current repository
- the exported files should overwrite the JSON snapshots in `crispybrain/workflows/`

You can override the container name with:

```sh
N8N_CONTAINER=my-n8n scripts/workflows/export-active-from-docker.sh
```

### Equivalent manual export

From a running n8n container:

```sh
docker exec ai-n8n n8n export:workflow --id='crispybrain-assistant' --pretty --output='/tmp/crispybrain-assistant.json'
docker cp ai-n8n:/tmp/crispybrain-assistant.json crispybrain/workflows/crispybrain-assistant.json
```

Repeat for all 7 active CrispyBrain workflows.

## Import Workflows Into a Fresh n8n Instance

### Helper wrapper

For a fresh Docker-based n8n container, use:

```sh
CONFIRM_IMPORT=I_UNDERSTAND scripts/workflows/import-exported-into-docker.sh
```

This imports the exported JSON files into the running container. It does not create credentials and it does not validate the workflows after import.

### Equivalent manual import

Copy the exported JSON directory into the container and import it:

```sh
docker cp crispybrain/workflows/. ai-n8n:/tmp/crispybrain-workflows
docker exec ai-n8n n8n import:workflow --separate --input=/tmp/crispybrain-workflows
```

If you use multi-user or project-based n8n, you may need `--userId` or `--projectId`.

## What Must Be Configured After Import

The imported workflows expect:

- an n8n credential named `Postgres account`
- Postgres reachable from n8n using the Compose host name `postgres`
- Ollama reachable from n8n at `http://host.docker.internal:11434`
- the Ollama models:
  - `llama3`
  - `nomic-embed-text`

The workflows also call each other through local webhook URLs on `127.0.0.1:5678`, so all imported CrispyBrain workflows should be present before you start activating and testing them.

## Import Order

Strict import order does not appear to matter for the current exported set because the workflows reference each other by webhook path rather than by imported n8n object IDs.

Recommended practice:

1. import the whole `crispybrain/workflows/` directory
2. configure credentials
3. activate the workflow set
4. test the full chain

## How To Avoid Drift

- treat `crispybrain/workflows/` as the canonical repo snapshot
- re-export after any meaningful n8n UI change
- do not edit exported JSON casually by hand unless you are making a deliberate repo-side change
- review `git diff` on workflow JSON before committing
- keep runtime credential names stable, or update the workflows after import

## Host Dependencies

The current workflows depend on host services, not just Compose services:

- Ollama on the host at `host.docker.internal:11434`

That means a fresh environment needs both:

- the minimum Compose stack
- a working host Ollama runtime

## Recommended Operator Checklist Before Commit

- export the active workflows again
- confirm exactly 7 core workflow files exist in `crispybrain/workflows/`
- review diffs for changed webhook paths, model names, SQL, and credential references
- verify README/setup docs still match the exports
- verify the `Postgres account` credential expectation has not changed
- verify the Ollama endpoints and model names have not changed
- only then commit the workflow JSON updates
