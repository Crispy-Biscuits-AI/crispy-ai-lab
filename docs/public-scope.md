# Public Scope

## What This Repo Is

This repo is the public core for CrispyBrain.

It is meant to describe and support:

- the exported CrispyBrain n8n workflow layer
- the Postgres memory schema
- the minimum runtime path for ingest, retrieval, and answer generation
- the practical operator flow for standing up and maintaining that core

## What Counts As Public Core

- `crispybrain/workflows/`
- `crispybrain/inbox/`
- `postgres/init/001-crispybrain.sql`
- `docker-compose.minimal.yml`
- setup, operator, workflow-sync, and release docs

## What Is Optional

Optional means:

- useful for local exploration or future integrations
- not required for a minimum CrispyBrain deployment
- not the default story for new adopters

Examples:

- broader Compose services in `docker-compose.yml`
- materials under `optional/`

## What Is Archived

Archived means:

- older experiments
- legacy compose paths
- repetitive test artifacts
- material preserved for reference, not for default use

Archived material should not shape a new visitor’s mental model of the product.

## What Is Intentionally Out Of Scope

This repo should not imply that it contains every adjacent system or internal integration.

Out of scope unless intentionally published later:

- CMS implementation details
- private client integrations
- internal operations notes
- unpublished product lines or consulting-only systems

## CMS Boundary

CMS is not part of the current public CrispyBrain product story.

If CMS or any related system is ever published later, it should be done intentionally with:

- its own documented scope
- its own public readiness review
- a clear explanation of how it relates to CrispyBrain

Until then, the public story should stay centered on CrispyBrain itself.
