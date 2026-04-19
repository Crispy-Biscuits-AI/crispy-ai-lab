# Release Checklist

## Before First Public Release

- choose and add a real license
- review `.env.example` for safe placeholder values only
- confirm `.env` remains untracked
- confirm README still reflects the current CrispyBrain core honestly
- confirm `docker-compose.minimal.yml` is the recommended public starting point
- confirm exported workflow JSON matches the live active CrispyBrain workflows
- confirm setup docs match the exported workflows and current credential expectations
- review `optional/` and `archive/` for anything that still feels too internal or too confusing
- review `docs/private-boundary-notes.md`
- review `docs/open-source-readiness-audit.md`

## Before Each Tagged Release

- re-export the active workflows
- review `git diff` on workflow JSON carefully
- verify the minimum stack docs still match runtime behavior
- verify Ollama model assumptions have not changed
- verify the `Postgres account` credential expectation has not changed
- verify no secret-like values were added to tracked files
