# Public Release Recommendation

## Is The Repo Close To Public-Ready?

Yes, it is close.

The repo now has:

- a clear CrispyBrain-first story
- exported active workflow logic
- a minimum stack
- operator/setup docs
- workflow sync guidance
- optional/archive separation

That is enough to make it understandable and credible for a technical public audience.

## Last Important Blockers

### 1. Release discipline

The MIT license is now in place, so the remaining work is mostly about keeping docs, workflow exports, and local assumptions aligned.

### 2. Public polish around residual private-adjacent traces

Examples:

- CMS-related category rows in the schema
- broader optional stack material that could still distract from the core story
- runtime naming debt like `openbrain_chat_turns`

These are not all blockers, but they should be consciously accepted if the repo is published before further cleanup.

### 3. External dependency clarity

A public release should be comfortable saying:

- Ollama runs on the host
- n8n credentials must be configured manually
- workflow exports can drift if operators do not re-export after changes

Those points are now documented, but they remain part of the operational reality.

## What Can Wait Until After Release

- full cleanup of inactive live n8n workflow clutter
- cosmetic container renaming
- staged migration away from `openbrain_chat_turns`
- further slimming of the broader optional Compose stack
- deeper pruning of archive material

## Naming Recommendation

Short term:

- keep the repo name `crispy-ai-lab` if that is the current stable location
- but make the public-facing story explicitly CrispyBrain-first everywhere

Longer term:

- consider whether the public repo identity should become more directly CrispyBrain-branded
- especially if this repo becomes the main public home for the product rather than a broader lab shell

Recommendation:

- do not rename automatically now
- keep the current repo name for continuity
- continue positioning it as the lab/runtime companion to the `crispybrain` product repo
