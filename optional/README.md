# Optional Components

This directory holds non-core configuration kept for reference or possible future use.

These items are intentionally outside the minimum CrispyBrain deployment story.

- `litellm/`: config for a LiteLLM layer that is not part of the current confirmed CrispyBrain path
- `openclaw/`: config for OpenClaw-related experimentation

Nothing in this directory is required by:

- `docker-compose.minimal.yml`
- the exported CrispyBrain workflow chain
- the minimum operator quickstart

If something in `optional/` becomes part of the current product path later, it should be moved back into the core repo story deliberately rather than by accident.
