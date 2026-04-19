#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
N8N_CONTAINER="${N8N_CONTAINER:-ai-n8n}"
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

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is required" >&2
  exit 1
fi

if ! docker exec "$N8N_CONTAINER" true >/dev/null 2>&1; then
  echo "Cannot reach n8n container: $N8N_CONTAINER" >&2
  exit 1
fi

mkdir -p "$OUT_DIR"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

for workflow_id in "${WORKFLOWS[@]}"; do
  echo "Exporting $workflow_id"
  docker exec "$N8N_CONTAINER" sh -lc "rm -f /tmp/${workflow_id}.json && n8n export:workflow --id='${workflow_id}' --pretty --output='/tmp/${workflow_id}.json' >/dev/null"
  docker cp "$N8N_CONTAINER:/tmp/${workflow_id}.json" "$TMP_DIR/${workflow_id}.json"
  mv "$TMP_DIR/${workflow_id}.json" "$OUT_DIR/${workflow_id}.json"
done

echo "Export complete."
echo "Review changes in: $OUT_DIR"
echo "Recommended next step: git diff crispybrain/workflows"
