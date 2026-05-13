---
name: core-workflow-contract
description: "Detailed team workflow contract for planning, handoff, verification, memory/spec recovery, and closeout."
---

# Core Workflow Contract

## Source Priority

System/developer/user instructions > current repo files > spec > command evidence > repo memory > external references.

## Default Flow

1. Init if repo facts are missing.
2. Parse intent and success criteria.
3. Freeze scope and non-goals.
4. Plan if task is MEDIUM/LARGE.
5. Review design when blast radius is non-trivial.
6. Implement through the right specialist.
7. Verify with concrete evidence.
8. Close with memory/spec recovery notes when useful.
9. Evolve only from verified signals: repeated failures, user corrections, review loops, stale triggers, missing verification, or recurring workflow friction.

## Handoff Rules

- PM sends minimal frozen packets.
- Specialists do not ask the user directly when delegated.
- Missing context returns `NEEDS_CONTEXT`.
- Write sets must not overlap for parallel implementation.

## Memory / Spec

- Spec is authoritative for requirements, design, and tasks.
- Memory is only a recovery index: current focus, decisions, last verification, next action.
- EvolutionEvents are compact memory records for accepted workflow improvements; each needs signal, target, mutation, validation, rollback, and status.
- Do not store secrets, PII, raw long logs, or unverified guesses.
