# Live n8n Cleanup Plan

## Purpose

This document describes how to clean up the remaining live n8n clutter later without risking the working CrispyBrain path today.

This pass does not delete anything from the live n8n database.

## Current Snapshot

Observed workflow counts in the live n8n database:

- 96 total workflows
- 7 active workflows
- 89 inactive workflows
- 49 archived workflows

There are multiple duplicate and legacy names, especially in the `openbrain-*` family.

Examples with repeated legacy names:

- `openbrain-auto-ingest-watch` appears many times
- `openbrain-answer-from-memory` appears many times
- `openbrain-ingest` appears many times
- `openbrain-build-context` appears multiple times

## What Kinds Of Live Clutter Remain

- inactive generic workflows such as `assistant`, `ingest`, and `build-context`
- inactive legacy `openbrain-*` workflows
- archived experiments and duplicates
- old manual/imported workflows such as `My workflow` and `My workflow 2`

## What Should Be Exported Before Any Deletion

Before deleting or permanently archiving any live workflow:

1. export all active CrispyBrain workflows again
2. export all inactive workflows you plan to review or remove
3. capture a database backup or at least workflow metadata snapshot
4. record workflow IDs, names, `active`, and `isArchived` state

Recommended safety export:

```sh
docker exec ai-n8n n8n export:workflow --all --pretty --separate --output=/tmp/n8n-workflow-backup
docker cp ai-n8n:/tmp/n8n-workflow-backup ./archive/n8n-runtime-backup
```

## What Should Be Archived In n8n First

If future cleanup happens inside n8n itself:

- first archive clearly inactive legacy workflows
- do not delete immediately
- leave a review window before permanent removal

Preferred first-wave candidates:

- duplicate inactive `openbrain-*` workflows
- generic inactive drafts like `assistant`, `build-context`, and `ingest`
- obvious one-off test workflows

## How To Verify Active vs Inactive Safely

Before touching any workflow:

1. confirm whether `active = true`
2. check recent execution history
3. compare against the exported canonical set in `crispybrain/workflows`
4. verify that no external caller still depends on a legacy webhook path
5. export the candidate before any archive/delete action

Do not rely on the display name alone. Some legacy workflows have duplicate names with different IDs and different archive states.

## Rollback Strategy

If cleanup goes wrong:

1. restore from exported workflow JSON
2. re-import the deleted/archived workflows
3. reactivate only what is needed
4. restore from database backup if workflow metadata or execution linkage was damaged

The simplest rollback plan is to keep a full workflow export before every cleanup wave.

## Safer Cleanup Sequence

1. export everything
2. review inactive workflows by family:
   - generic drafts
   - `openbrain-*` duplicates
   - archived test workflows
3. move first-wave deletion candidates to archived state if not already archived
4. wait and verify no regressions
5. only then permanently remove a small batch

## What To Avoid

- deleting by name only
- mass-deleting all `openbrain-*` workflows
- deleting archived workflows without first exporting them
- assuming old workflows are safe to remove just because they are inactive

## Practical Goal

The goal is not just fewer workflows. The goal is a live n8n instance whose active set matches the repo’s exported CrispyBrain workflow set closely enough that operators trust Git and runtime again.
