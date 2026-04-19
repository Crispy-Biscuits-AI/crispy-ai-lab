# Workflow Sync

## Canonical Workflow Location

For the current public demo path, the canonical exported workflow snapshots live in the sibling `../crispybrain/workflows` repo checkout.

That workflow directory contains the current public-facing `assistant` flow, the `crispybrain-demo` wrapper workflow, and the demo repo's product-facing exports.

This lab repo also keeps older lab-side workflow exports under [`crispybrain/workflows`](../crispybrain/workflows), but they are not the primary onboarding path for the `localhost:8787` demo.

The live n8n instance is still editable, so operators must keep exports in sync intentionally.

## Export Updated Workflows From n8n

### Recommended local helper

Use [scripts/workflows/export-active-from-docker.sh](../scripts/workflows/export-active-from-docker.sh) when working against the local Docker-based n8n container.

```sh
scripts/workflows/export-active-from-docker.sh
```

Recommended override for the current public demo repo:

```sh
OUT_DIR=../crispybrain/workflows scripts/workflows/export-active-from-docker.sh
```

### Equivalent manual export

From the running local Compose stack:

```sh
docker compose exec -T n8n sh -lc \
  "n8n export:workflow --id='assistant' --pretty --output='/tmp/assistant.json' >/dev/null && cat /tmp/assistant.json" \
  > ../crispybrain/workflows/assistant.json
```

Repeat for the workflow IDs you want to refresh.

## Import Workflows Into a Fresh n8n Instance

### Helper wrapper

For a fresh Docker-based n8n container, use:

```sh
WORKFLOW_DIR=../crispybrain/workflows \
CONFIRM_IMPORT=I_UNDERSTAND \
scripts/workflows/import-exported-into-docker.sh
```

This imports the exported JSON files into the running container. It does not create credentials and it does not validate the workflows after import.

### Equivalent manual import

Copy the exported JSON files into the container and import them:

```sh
docker compose exec -T n8n sh -lc 'rm -rf /tmp/crispybrain-workflows && mkdir -p /tmp/crispybrain-workflows'
for workflow_file in ../crispybrain/workflows/*.json; do
  docker compose exec -T n8n sh -lc "cat > /tmp/crispybrain-workflows/$(basename "$workflow_file")" < "$workflow_file"
done
docker compose exec -T n8n n8n import:workflow --separate --input=/tmp/crispybrain-workflows
```

If you use multi-user or project-based n8n, you may need `--userId` or `--projectId`.

## What Must Be Configured After Import

The imported workflows expect:

- an n8n credential named `Postgres account`
- Postgres reachable from n8n using the Compose host name `postgres`
- Ollama reachable from n8n at `http://host.docker.internal:11434`
- the Ollama models `llama3` and `nomic-embed-text`

The current public demo flow also depends on the demo wrapper workflow `crispybrain-demo`, which forwards requests into `assistant`.

## Import Order

Strict import order does not appear to matter for the current exported set because the workflows reference each other by webhook path rather than by imported n8n object IDs.

Recommended practice:

1. import the whole `../crispybrain/workflows/` directory
2. configure credentials
3. activate the workflow set
4. test the full chain

## How To Avoid Drift

- treat the workflow directory you actually import from as the canonical repo snapshot
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
- confirm the expected workflow files exist in the directory you consider canonical
- review diffs for changed webhook paths, model names, SQL, and credential references
- verify README/setup docs still match the exports
- verify the `Postgres account` credential expectation has not changed
- verify the Ollama endpoints and model names have not changed
- only then commit the workflow JSON updates
