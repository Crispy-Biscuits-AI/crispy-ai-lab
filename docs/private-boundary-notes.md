# Private Boundary Notes

## Purpose

This document describes what kinds of material should stay out of the public CrispyBrain repo even if they exist in internal environments or adjacent systems.

## Keep Private Or Separate

- client-specific credentials, endpoints, and deployment details
- customer data, example data derived from customer work, and private project notes
- private operational runbooks that assume internal infrastructure
- unpublished adjacent systems or product lines
- internal consulting shortcuts that do not belong in the public architecture story

## Why This Matters

The public repo should teach one clean thing well:

- what CrispyBrain is
- how to run the current core
- how to maintain its workflow layer safely

It should not become a dumping ground for every nearby experiment or internal dependency.

## CMS Boundary

CMS may be relevant internally or strategically, but it should remain out of scope for this public repo unless intentionally published later.

Reasons:

- it is not part of the current minimum CrispyBrain runtime story
- including it loosely would blur the product boundary
- it would make the public architecture harder to explain
- it would increase the risk of leaking private assumptions into the public core

## Good Public Repo Discipline

Before adding something to this repo, ask:

1. does this directly support the public CrispyBrain core?
2. would a new outsider understand why it is here?
3. can it be documented without relying on private context?

If the answer is no, it should probably stay private, move to an internal repo, or wait for a later intentional publication decision.
