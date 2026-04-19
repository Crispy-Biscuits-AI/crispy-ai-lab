# Removal Candidates

## Archive First

| Item | Reason |
| --- | --- |
| `archive/experiments/compose/mock.yml` | Old alternate stack with stale `ai-lab` naming, Redis, and a divergent architecture that does not match the active CrispyBrain path |
| `optional/openclaw/openclaw.json` | Only relevant if OpenClaw stays in scope; current repo evidence does not show it serving the active CrispyBrain workflow path |
| `archive/experiments/watch-tests/final-watch-test.txt` | Test artifact rather than product asset |
| `archive/experiments/watch-tests/final-watch-test-2.txt` | Test artifact rather than product asset |
| `archive/experiments/watch-tests/final-watch-test-3.txt` | Test artifact rather than product asset |
| `archive/experiments/watch-tests/final-watch-test-4.txt` | Test artifact rather than product asset |
| `archive/experiments/watch-tests/final-watch-test-5.txt` | Test artifact rather than product asset |
| `archive/experiments/watch-tests/final-watch-test-6.txt` | Test artifact rather than product asset |
| `archive/experiments/watch-tests/final-watch-test-7.txt` | Test artifact rather than product asset |
| `archive/experiments/watch-tests/final-watch-test-8.txt` | Test artifact rather than product asset |

## Remove Later

| Item | Reason |
| --- | --- |
| `optional/litellm/litellm-config.yaml` | Only supports a LiteLLM layer that currently appears redundant with direct Ollama usage |
| `litellm` service in `docker-compose.yml` | Active workflows do not use it |
| `qdrant` service in `docker-compose.yml` | Unused in active workflows and empty at runtime |
| `openclaw` service in `docker-compose.yml` | No active workflow references it |
| `browser` service in `docker-compose.yml` | Only exists to support OpenClaw |
| `open-webui` service in `docker-compose.yml` | Not part of the current CrispyBrain execution path |
| `adminer` service in `docker-compose.yml` | Debugging convenience, not product runtime |
| `.DS_Store` files | Finder noise that does not belong in the repo at all |

## Keep For Future

| Item | Reason |
| --- | --- |
| `README.md` | Needs rewriting, but the repo still needs a top-level explanation |
| `crispybrain/inbox/crispybrain-seed-memories.txt` | Useful as a seed/example for the memory ingestion story |
| `crispybrain/inbox/alpha/watch-test.txt` | Useful as one concise example of how project-routed auto-ingest works |
| `open-webui` | Potentially useful for demos or internal convenience even if not part of the minimum product stack |
| `adminer` | Potentially useful for internal debugging during consulting or support |

## Unclear

| Item | Reason |
| --- | --- |
| `open-webui` | Could be a useful client-facing demo surface, but repo evidence does not prove that clients need it |
| `adminer` | Useful for operators, but probably not for customers; whether to keep it depends on the support model |
| stale runtime names like `openbrain_chat_turns` | Not a tracked file/folder problem, but a real naming debt in the live workflow/database layer |
| inactive n8n workflows in Postgres | They are not in the repo, but they are clear operational clutter and should be triaged/exported/archived separately |

## Most Important Non-Destructive Recommendation

Before deleting any of the candidate items above, export and version the 7 active CrispyBrain workflows. That step reduces cleanup risk more than any file deletion would.
