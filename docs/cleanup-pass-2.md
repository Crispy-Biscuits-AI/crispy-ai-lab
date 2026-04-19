# Cleanup Pass 2

## What Was Preserved

- the 7 active CrispyBrain workflows were exported from the live n8n instance into [crispybrain/workflows](../crispybrain/workflows)
- the current Postgres memory schema remained in place at [postgres/init/001-crispybrain.sql](../postgres/init/001-crispybrain.sql)
- the current inbox mental model remained in place at [crispybrain/inbox](../crispybrain/inbox)
- the broader `docker-compose.yml` stack was preserved rather than deleted

## What Was Moved or Quarantined

- `litellm-config.yaml` moved to [optional/litellm/litellm-config.yaml](../optional/litellm/litellm-config.yaml)
- `openclaw.json` moved to [optional/openclaw/openclaw.json](../optional/openclaw/openclaw.json)
- `mock.yml` moved to [archive/experiments/compose/mock.yml](../archive/experiments/compose/mock.yml)
- repetitive `final-watch-test*.txt` files moved to [archive/experiments/watch-tests](../archive/experiments/watch-tests)

## What Was Removed

- obvious Finder garbage:
  - `.DS_Store`
  - `crispybrain/.DS_Store`
  - `crispybrain/inbox/.DS_Store`

## What Was Left Untouched Intentionally

- `docker-compose.yml` still contains the broader local stack because this pass favored reversible cleanup over breaking existing local habits
- optional services like LiteLLM, Open WebUI, OpenClaw, Qdrant, and Adminer were not deleted from the full stack yet
- SQL naming debt inside runtime tables and workflow SQL, such as `openbrain_chat_turns`, was left alone because it is operationally riskier than file cleanup
- inactive n8n workflows stored in the database were not deleted in this pass

## New Minimum Deployment Story

The new default consulting and client story is:

- use [docker-compose.minimal.yml](../docker-compose.minimal.yml)
- run:
  - `n8n`
  - `Postgres` with `pgvector`
- keep Ollama on the host machine
- load and maintain the exported workflow set under [crispybrain/workflows](../crispybrain/workflows)
- configure the required n8n Postgres credential after workflow import

## Remaining Manual Action

- decide whether the broader `docker-compose.yml` should eventually be slimmed or split into explicit optional profiles
- decide whether Open WebUI and Adminer should remain available as optional consulting tools
- decide whether stale inactive n8n workflows in the live database should be exported, archived, or deleted
- re-export workflows whenever n8n UI edits are made
- define a repeatable way to create or remap the `Postgres account` credential in new environments

## Suggested Pass Three

1. import/export discipline:
   - establish a repeatable workflow sync process between n8n and Git
2. stack cleanup:
   - remove LiteLLM, Qdrant, OpenClaw, browser, and possibly Open WebUI/Adminer from the default stack
3. runtime cleanup:
   - triage the inactive workflows and old runtime naming debt
4. client polish:
   - refine environment handling, remove absolute assumptions, and tighten deployment docs further
