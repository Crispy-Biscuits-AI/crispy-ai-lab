# Open Source Readiness Audit

## Summary

`crispy-ai-lab` is much closer to public-ready than it was before cleanup. The repo now has a clearer CrispyBrain-first story, exported workflow logic, a minimum stack, and a cleaner separation between core, optional, and archived material.

The main remaining public-release issues are not catastrophic leaks, but boundary and polish issues:

- no license has been chosen yet
- the repo still contains optional/private-adjacent context that should stay clearly out of scope
- some legacy naming and domain residue remain in runtime-sensitive places
- the working product still depends on external setup, especially n8n credentials and host Ollama

## Ready Now

- exported active CrispyBrain workflows are in `crispybrain/workflows/`
- minimum deployment path exists in `docker-compose.minimal.yml`
- `.env` is ignored and not tracked
- `.env.example` exists
- setup, operator, and workflow-sync docs exist
- optional and archived material are separated from the core story
- no tracked secret values were found in the public-core files that should be published as-is

## Needs Cleanup Before Public Release

- choose and publish a real license
- review whether `docker-compose.yml` should stay in public form as a broad optional stack or be documented more strongly as secondary
- review the SQL category names `cms_signal` and `cms_reason_code` in `postgres/init/001-crispybrain.sql`
  - these are not secrets, but they are private-adjacent domain residue and may confuse public readers
- decide whether archived experimental files should all remain in the initial public launch or whether some should be pruned before first release
- confirm the public release should include the exported workflow JSON exactly as currently written
  - especially the direct `host.docker.internal:11434` and `openbrain_chat_turns` assumptions

## Safe To Leave As-Is

- host Ollama assumption documented in setup docs
- `optional/` content preserved for reference rather than deleted
- `archive/` content preserved for traceability rather than deleted
- workflow sync helper scripts that are intentionally small and honest
- legacy naming debt docs that explain but do not rename runtime-sensitive identifiers

## Unclear / Review Manually

- whether Open WebUI and Adminer should remain visible in the broader public repo story at all
- whether `docker-compose.yml` should stay tracked as the broad local stack or move further into optional examples later
- whether public adoption would be smoother if the repo eventually becomes more explicitly CrispyBrain-branded than `crispy-ai-lab`
- whether the schema’s CMS-related category rows should stay for compatibility or be removed in a future migration

## Specific Risks Reviewed

### Secrets or Secret-Like Values

- tracked files: no active secrets found that should obviously block public release
- local `.env`: contains secret-like values but is ignored and untracked

### Personal or Local Machine Assumptions

- host Ollama assumption is real and documented
- no remaining absolute local path links were left in tracked Markdown docs after this pass

### Internal-Only or Unsupported Story Risk

- the repo is now much more CrispyBrain-first
- optional and archived material are still present, so the README and scope docs need to remain disciplined

### Public Impression Risk

- the repo is credible for a technical audience now
- biggest remaining impression blocker is licensing and a few signs of internal history, not hidden secrets
