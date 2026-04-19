#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUT_DIR="${OUT_DIR:-$REPO_ROOT/crispybrain/workflows}"

WORKFLOWS=(
  "crispybrain-answer-from-memory"
  "crispybrain-assistant"
  "crispybrain-auto-ingest-watch"
  "crispybrain-build-context"
  "crispybrain-ingest"
  "crispybrain-project-memory"
  "crispybrain-validation-and-errors"
)

compose() {
  (
    cd "$REPO_ROOT"
    docker compose "$@"
  )
}

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is required" >&2
  exit 1
fi

if ! compose exec -T n8n true >/dev/null 2>&1; then
  echo "Cannot reach the local n8n service through docker compose" >&2
  exit 1
fi

mkdir -p "$OUT_DIR"

for workflow_id in "${WORKFLOWS[@]}"; do
  echo "Exporting $workflow_id"
  compose exec -T n8n sh -lc "rm -f /tmp/${workflow_id}.json && n8n export:workflow --id='${workflow_id}' --pretty --output='/tmp/${workflow_id}.json' >/dev/null && cat /tmp/${workflow_id}.json" > "$OUT_DIR/${workflow_id}.json"
done

echo "Export complete."
echo "Review changes in: $OUT_DIR"
echo "Recommended next step: git diff -- $OUT_DIR"
