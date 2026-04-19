# Client Deploy Shape

## What This Product Is

CrispyBrain is a lightweight memory assistant system. It takes notes, files, or messages, stores them as structured memory, retrieves the most relevant context later, and uses a local language model to answer with that context in mind.

In plain English:

- you send CrispyBrain information
- it saves the useful parts
- later you ask a question
- it finds the most relevant memory
- it answers using that memory

## What Services It Needs

For the current practical product path, a client only appears to need:

- `n8n` to run the workflows
- `Postgres` with `pgvector` to store memory and embeddings
- `Ollama` to generate embeddings and answers

That is the simplest honest deployment story supported by the current evidence.

## What a Client Would Run

The clean client story should be:

1. start Postgres
2. start n8n
3. connect n8n to Ollama
4. load the CrispyBrain workflows
5. configure the Postgres credential the workflows expect
6. send notes or questions into CrispyBrain through its webhooks or a thin UI

## What Has Intentionally Been Left Out

To keep deployment simple and explainable, the following should be left out of the default client story unless there is a clear future need:

- LiteLLM
- Qdrant
- Open WebUI
- OpenClaw
- the OpenClaw browser sidecar
- Adminer

Those tools may be useful for experiments, demos, or internal operations, but they do not currently appear necessary for the core CrispyBrain value proposition.

## The Plain-English Customer Explanation

"CrispyBrain is a memory layer for your work. It helps capture notes and project knowledge, stores them in a searchable way, and uses a local AI model to answer with that stored context. The system is designed to be small and self-hosted rather than a sprawling AI platform."

## The Main Deployment Caveat Right Now

The repo is in a better state now because the active workflows have been exported into `crispybrain/workflows`. The remaining caveats are that n8n is still a live editing surface, so exported JSON and runtime state can drift if workflow changes are not re-exported, and that imported workflows still require n8n credential setup.
