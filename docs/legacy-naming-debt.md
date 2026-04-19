# Legacy Naming Debt

## Purpose

This document maps the remaining legacy naming debt in CrispyBrain without performing risky runtime renames.

The main rule for now:

- document first
- migrate later
- do not casually rename runtime-sensitive identifiers

## Current Legacy Names Found

## 1. `openbrain_chat_turns`

Where it appears:

- active exported workflow [crispybrain-assistant.json](/Users/elric/repos/crispy-ai-lab/crispybrain/workflows/crispybrain-assistant.json)
- live Postgres table `public.openbrain_chat_turns`
- associated indexes, constraints, and sequence in Postgres

Current usage:

- the assistant workflow reads recent session turns from `openbrain_chat_turns`
- the assistant workflow inserts both user and assistant messages into `openbrain_chat_turns`

Classification:

- runtime-sensitive

Why it matters:

- changing this carelessly would break the current assistant flow
- table renames would also affect indexes, constraints, and any undocumented downstream queries

## 2. Old `openbrain-*` workflow names in live n8n

Where they appear:

- live n8n database only
- inactive workflow records, many of them archived

Observed snapshot:

- 96 total workflows
- 7 active
- 89 inactive
- 49 archived
- many inactive duplicates still use `openbrain-*` names

Examples:

- `openbrain-auto-ingest-watch`
- `openbrain-answer-from-memory`
- `openbrain-build-context`
- `openbrain-ingest`
- `openbrain-validation-and-errors`

Classification:

- live clutter
- low risk to leave alone for now
- potentially removable later after export and verification

## 3. `ai-*` container names in Compose

Where they appear:

- `docker-compose.yml`

Examples:

- `ai-n8n`
- `ai-postgres`
- `ai-open-webui`

Classification:

- mostly cosmetic / operational

Why it matters:

- they are visible in Docker tooling
- they can confuse operators because they do not say `crispybrain`
- they are less risky than table renames, but still can affect scripts and habits

## 4. Archived `ai-lab` naming

Where it appears:

- [archive/experiments/compose/mock.yml](/Users/elric/repos/crispy-ai-lab/archive/experiments/compose/mock.yml)

Classification:

- cosmetic inside archived material

Why it matters:

- low risk because it is quarantined
- should not be used as a current reference

## What Is Cosmetic vs Runtime-Sensitive

### Cosmetic or lower-risk

- archived `ai-lab` names in quarantined files
- `ai-*` container names in Compose
- inactive old workflow display names in n8n

### Runtime-sensitive

- `openbrain_chat_turns` table
- SQL queries in active exported workflows that read/write that table
- any credential or webhook names depended on by the active workflow chain

## Recommended Migration Order

1. keep exporting the active workflows so the repo stays aligned
2. export or snapshot the live database schema and active workflow set before any runtime rename
3. if chat-turn naming must change, introduce a new compatibility path first
4. update workflow SQL in a staging/test environment
5. validate reads, writes, and session history behavior
6. only then consider retiring the old `openbrain_chat_turns` naming
7. handle cosmetic compose/container naming after the workflow and database path is stable

## Safe Future Migration Approach For `openbrain_chat_turns`

The safest likely sequence is:

1. create a new `crispybrain_chat_turns` table or compatibility layer
2. backfill data from `openbrain_chat_turns`
3. update exported workflows to read/write the new target in staging
4. verify session history and assistant behavior
5. cut over production/runtime
6. only later consider dropping or renaming the legacy table

## What Should Not Be Renamed Casually

- `openbrain_chat_turns`
- its indexes, sequence, and constraints
- SQL embedded in the active exported workflows
- live inactive workflow records before they are exported/snapshotted

These names are technical debt, but they are still part of the working runtime path and need a controlled migration, not a cleanup search-and-replace.
