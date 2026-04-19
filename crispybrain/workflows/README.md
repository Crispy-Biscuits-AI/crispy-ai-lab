# CrispyBrain Workflows

This directory contains exported JSON snapshots of the currently active CrispyBrain n8n workflows.

These exports were taken from the live n8n instance so the repo now contains the real current product logic instead of only the surrounding infrastructure.

## Core Workflow Set

| Workflow | Purpose |
| --- | --- |
| `crispybrain-auto-ingest-watch.json` | Accepts watch-style file or content payloads, infers project routing, and forwards valid items into the ingest path |
| `crispybrain-ingest.json` | Normalizes content, chunks it, requests embeddings from Ollama, and stores memory records in Postgres |
| `crispybrain-build-context.json` | Builds retrieval context for a query by embedding it and looking up relevant memory in Postgres |
| `crispybrain-answer-from-memory.json` | Turns a prepared context bundle into an answer by calling Ollama generation |
| `crispybrain-assistant.json` | Orchestrates the higher-level assistant flow, including session turns, context building, and answer generation |
| `crispybrain-project-memory.json` | Provides project-scoped memory lookup and filtering behavior |
| `crispybrain-validation-and-errors.json` | Normalizes request validation and error shaping for the CrispyBrain workflow family |

## Current Relationship Between Workflows

The current product chain is roughly:

1. `crispybrain-auto-ingest-watch`
2. `crispybrain-ingest`
3. `crispybrain-build-context`
4. `crispybrain-answer-from-memory`
5. `crispybrain-assistant`

Supporting workflows:

- `crispybrain-project-memory`
- `crispybrain-validation-and-errors`

## Important Note

These files are exported snapshots. n8n remains a live editing surface, so if someone changes a workflow in the n8n UI, the export in this folder must be refreshed to keep Git aligned with runtime reality.

The exports also reference an n8n credential named `Postgres account`. In a fresh n8n instance, that credential must be recreated or remapped after import.
