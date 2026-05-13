---
id: workflow-rules
type: repo-memory
updated_at: 2026-05-13
status: active
priority: high
tags: [workflow, memory, prompt, spec, token-budget]
---

# Workflow Rules

## One-line Summary

Use Markdown-based memory routing and stable-prefix prompt assembly to keep context small while preserving current progress.

## Current State

- Memory is split into always-on, task memory, and archive/logs.
- `INDEX.md` routes by tags, use_for, load_tier, and linked_spec.
- `current-workstreams.md` stores current focus, next resume action, last verified evidence, and links to spec/memory.
- `evolution-loop` turns repeated failures, user corrections, review loops, stale triggers, and verification gaps into auditable EvolutionEvents.
- Memory retrieval follows progressive disclosure: index first, then timeline/context, then exact shard only when needed.

## Decisions

- 2026-05-11: Use Markdown-based Memory System instead of vector RAG for small and medium knowledge bases.
- 2026-05-11: Prompt assembly order is stable prefix -> routing index -> current state -> relevant shards -> current user input.
- 2026-05-11: Long logs, raw webpages, full old specs, and full old memory files are cache=false style inputs and are loaded only on demand.
- 2026-05-13: Adopt bounded evolution: Read verified signals -> Select target -> Propose mutation -> Validate -> Write accepted learning.

## Constraints

- Memory never overrides current repo files or user instructions.
- Spec remains the authoritative source for requirements, design, and task acceptance.
- Memory stores status, decisions, recovery hints, and verified learnings only.
- Evolution never performs autonomous free-form rewrites; every accepted event needs signal, target, mutation, validation, rollback, and status.
- `<private>...</private>` content must be excluded from durable memory and public docs.

## Open Questions

- Which final GitHub owner/repository should replace README install-command placeholders before publication?
- Which optional heavy skills should be packaged later as separate add-on plugins?
