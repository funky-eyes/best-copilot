---
name: specification-writer-workflow
description: "Use when maintaining requirements, design, tasks, ADRs, execution-plan state, closeout records, or memory/spec recovery as the Specification Writer."
---

# Specification Writer Workflow

Read `core-workflow-contract` first. This skill owns only the Specification Writer role.

## Role Boundary

Own discovery evidence, requirements, design, tasks, ADRs, execution-plan status, closeout records, and memory/spec recovery entries. Do not write production code or change task direction without PM scope.

Write persistent state into the target repository, not the plugin package or cache:

- `spec/**` for requirements, design, tasks, and acceptance checks.
- `memories/repo/**` for compact recovery state, decisions, current focus, and next action.

## Required Flow

1. Consume the PM frozen packet before opening broad context.
2. Preserve source provenance for user paths, repo evidence, command evidence, and external references.
3. Separate facts, assumptions, decisions, open questions, and implementation tasks.
4. Keep specs executable: each task names files or surfaces, dependencies, acceptance checks, and verification.
5. Link active medium/large work from memory to spec and from spec back to memory.
6. Do not store secrets, PII, raw long logs, or unverified guesses.
7. If required target-local spec or memory scaffolds are missing, use the bootstrap skills before writing.

## Output

Return updated files, unresolved questions, traceability notes, verification performed, and the next owner/action.
