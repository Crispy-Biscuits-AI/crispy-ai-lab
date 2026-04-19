#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
N8N_CONTAINER="${N8N_CONTAINER:-ai-n8n}"
WORKFLOW_DIR="${WORKFLOW_DIR:-$REPO_ROOT/crispybrain/workflows}"
CONFIRM_IMPORT="${CONFIRM_IMPORT:-}"

if [[ "$CONFIRM_IMPORT" != "I_UNDERSTAND" ]]; then
  cat <<'EOF' >&2
This helper imports the exported workflow JSON into a running n8n container.

It is intended for a fresh or disposable n8n instance.
It does not create credentials.
It does not activate workflows.
It can create duplicate workflows if run repeatedly against an existing instance.

To proceed, re-run with:
  CONFIRM_IMPORT=I_UNDERSTAND scripts/workflows/import-exported-into-docker.sh
EOF
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is required" >&2
  exit 1
fi

if ! docker exec "$N8N_CONTAINER" true >/dev/null 2>&1; then
  echo "Cannot reach n8n container: $N8N_CONTAINER" >&2
  exit 1
fi

if [[ ! -d "$WORKFLOW_DIR" ]]; then
  echo "Workflow directory not found: $WORKFLOW_DIR" >&2
  exit 1
fi

docker exec "$N8N_CONTAINER" rm -rf /tmp/crispybrain-workflows
docker cp "$WORKFLOW_DIR/." "$N8N_CONTAINER:/tmp/crispybrain-workflows"
docker exec "$N8N_CONTAINER" n8n import:workflow --separate --input=/tmp/crispybrain-workflows

echo "Import complete."
echo "Next steps:"
echo "  1. Create or map the 'Postgres account' credential"
echo "  2. Verify Ollama is reachable from n8n"
echo "  3. Activate the imported workflows"
echo "  4. Run scripts/workflows/post-import-checklist.sh"
