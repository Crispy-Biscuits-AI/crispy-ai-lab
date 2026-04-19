#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
WORKFLOW_DIR="${WORKFLOW_DIR:-$REPO_ROOT/crispybrain/workflows}"
CONFIRM_IMPORT="${CONFIRM_IMPORT:-}"

compose() {
  (
    cd "$REPO_ROOT"
    docker compose "$@"
  )
}

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

if ! compose exec -T n8n true >/dev/null 2>&1; then
  echo "Cannot reach the local n8n service through docker compose" >&2
  exit 1
fi

if [[ ! -d "$WORKFLOW_DIR" ]]; then
  echo "Workflow directory not found: $WORKFLOW_DIR" >&2
  exit 1
fi

shopt -s nullglob
workflow_files=("$WORKFLOW_DIR"/*.json)

if [[ ${#workflow_files[@]} -eq 0 ]]; then
  echo "No workflow JSON files found in: $WORKFLOW_DIR" >&2
  exit 1
fi

compose exec -T n8n sh -lc 'rm -rf /tmp/crispybrain-workflows && mkdir -p /tmp/crispybrain-workflows'

for workflow_file in "${workflow_files[@]}"; do
  workflow_name="$(basename "$workflow_file")"
  echo "Copying $workflow_name"
  compose exec -T n8n sh -lc "cat > /tmp/crispybrain-workflows/$workflow_name" < "$workflow_file"
done

compose exec -T n8n n8n import:workflow --separate --input=/tmp/crispybrain-workflows

echo "Import complete."
echo "Imported from: $WORKFLOW_DIR"
echo "Next steps:"
echo "  1. Create or map the 'Postgres account' credential"
echo "  2. Verify Ollama is reachable from n8n"
echo "  3. Activate the imported workflows"
echo "  4. Run scripts/workflows/post-import-checklist.sh"
