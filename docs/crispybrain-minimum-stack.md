# CrispyBrain Minimum Stack

## Recommendation

The smallest credible stack for CrispyBrain right now is:

- `n8n`
- `Postgres` with `pgvector`
- `Ollama`

Everything else should be treated as optional, experimental, or outside the minimum client deployment story unless new evidence emerges.

## Required Services

| Service | Why it is needed |
| --- | --- |
| `n8n` | Holds the active CrispyBrain workflows and exposes the working webhooks |
| `Postgres` with `pgvector` | Stores memories, embeddings, metadata, and session-related data used by the workflows |
| `Ollama` | Provides both embedding generation (`/api/embed`) and response generation (`/api/generate`) directly to the active workflows |

## Required Repo Components

| Item | Why it matters |
| --- | --- |
| `docker-compose.minimal.yml` | Recommended minimum deployment entrypoint |
| `postgres/init/001-crispybrain.sql` | Memory schema required by the current workflow design |
| `crispybrain/workflows/*.json` | Exported active CrispyBrain workflows that preserve the current product logic |
| `crispybrain/inbox/` example input path | Supports the current auto-ingest mental model |

## Optional Services

| Service | Why it might stay optional |
| --- | --- |
| `adminer` | Useful for debugging during consulting or internal support |
| `open-webui` | Could be a simple local chat/demo UI, but not part of the confirmed core |

## Excluded Services

| Service | Why it should be excluded from the minimum stack |
| --- | --- |
| `litellm` | Active CrispyBrain workflows call Ollama directly; LiteLLM adds an extra layer without demonstrated current value |
| `qdrant` | No active workflow references it; live runtime has zero collections |
| `openclaw` | Not connected to the active CrispyBrain workflow chain |
| `browser` | Exists only to support OpenClaw |

## Deployment Reasoning

The live CrispyBrain flow is already simple in spirit:

1. receive text or query through an n8n webhook
2. call Ollama to embed or generate
3. store and retrieve memory data in Postgres
4. return a structured answer

That story does not require:

- a second vector store
- a model-routing layer
- a browser automation subsystem
- a second chat UI

## What a Client Actually Needs

For a client deployment, the practical needs appear to be:

- a machine running Docker
- access to an Ollama instance or compatible LLM endpoint
- Postgres with `pgvector`
- n8n loaded with the active CrispyBrain workflows
- an n8n Postgres credential configured for those imported workflows
- a small amount of deployment documentation

The client does not appear to need:

- Qdrant
- LiteLLM
- OpenClaw
- the OpenClaw browser sidecar
- Adminer in production

## Important Caveat

The repo now contains exported active workflows, which makes the minimum stack much more real and consultable. The remaining caveat is drift: if workflows are edited in the n8n UI and not re-exported, Git will stop reflecting runtime truth.
