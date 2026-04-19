#!/usr/bin/env bash
set -euo pipefail

cat <<'EOF'
Post-import checklist

1. Verify .env values match the target environment.
2. Verify Ollama is reachable at http://host.docker.internal:11434 from n8n.
3. Verify Ollama has models:
   - llama3
   - nomic-embed-text
4. Create an n8n credential named:
   - Postgres account
5. Verify the credential points at:
   - host: postgres
   - port: 5432
   - database: POSTGRES_DB
   - user: POSTGRES_USER
   - password: POSTGRES_PASSWORD
6. Activate the 7 exported CrispyBrain workflows.
7. Test ingest and assistant behavior before committing any workflow edits.
8. Re-export workflows back into crispybrain/workflows after runtime edits.
EOF
