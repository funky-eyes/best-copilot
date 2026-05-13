# Repo Memory Index

<!-- markdownlint-disable MD013 -->

This file is a routing table, not a directory listing. Read it first, then load only the 1-3 memory files or sections that match the current task.

## Retrieval Order

1. Read this index.
2. If resuming active work, read `current-workstreams.md`.
3. Follow `linked_spec` and `linked_memory`.
4. Load only the relevant section from the selected memory file.
5. Fall back to archive/logs only when source tracing is required.

## Routing Table

| File | Load tier | Tags | Use for | Linked spec | Last updated | One-line summary |
| --- | --- | --- | --- | --- | --- | --- |
| `current-workstreams.md` | task-active | resume, progress, active-spec, evolution | Resume current work and find next action | `spec/INDEX.md` | 2026-05-13 | Active `best-copilot` plugin/template/evolution release-readiness state |
| `project-state.md` | task-reference | project, status, goals, best-copilot, evolution | Current project state and important constraints | `spec/INDEX.md` | 2026-05-13 | Compact state file for the installable self-evolving `best-copilot` plugin/template |
| `workflow-rules.md` | task-reference | workflow, prompt, memory, spec, evolution | Memory retrieval, prompt assembly, spec-memory coordination, and EvolutionEvent rules | `spec/INDEX.md` | 2026-05-13 | RAG-lite plus bounded evolution rules for token-efficient agent work |
| `decisions.md` | task-reference | decisions, deprecated, evolution | Durable decisions and superseded decisions | `spec/INDEX.md` | 2026-05-13 | Date-stamped decisions including plugin install, lean skills, and evolution loop choices |
| `logs/README.md` | archive-reference | logs, recovery | Monthly or release logs, loaded only on demand | none | 2026-05-11 | Archive area for compressed logs |
| `archive/deprecated-decisions.md` | archive-reference | archive, deprecated | Historical decisions that should not guide new work by default | none | 2026-05-11 | Deprecated decisions and replacement links |

## Maintenance Rules

- Every new repo memory file must get one routing row here.
- Update `last_updated` and the one-line summary when a memory file changes.
- Do not paste long logs into this index.
- If a file grows beyond 200 lines or mixes topics, split it and update this table.
