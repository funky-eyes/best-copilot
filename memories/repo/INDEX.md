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
| `current-workstreams.md` | task-active | resume, progress, active-spec, evolution | Resume current work and find next action | `spec/INDEX.md` | 2026-05-13 | Active plugin/template state, including init detection and target-local memory/spec storage |
| `project-state.md` | task-reference | project, status, goals, best-copilot, evolution | Current project state and important constraints | `spec/INDEX.md` | 2026-05-13 | Compact state file for the installable plugin/template and target-local storage boundary |
| `workflow-rules.md` | task-reference | workflow, prompt, memory, spec, evolution | Memory retrieval, prompt assembly, spec-memory coordination, and EvolutionEvent rules | `spec/INDEX.md` | 2026-05-13 | RAG-lite, file-based init detection, target-local storage, and bounded evolution rules |
| `decisions.md` | task-reference | decisions, deprecated, evolution | Durable decisions and superseded decisions | `spec/INDEX.md` | 2026-05-13 | Date-stamped decisions including plugin install, init detection, target storage, and evolution |
| `logs/README.md` | archive-reference | logs, recovery | Monthly or release logs, loaded only on demand | none | 2026-05-11 | Archive area for compressed logs |
| `archive/deprecated-decisions.md` | archive-reference | archive, deprecated | Historical decisions that should not guide new work by default | none | 2026-05-11 | Deprecated decisions and replacement links |

## Maintenance Rules

- Every new repo memory file must get one routing row here.
- Update `last_updated` and the one-line summary when a memory file changes.
- Do not paste long logs into this index.
- If a file grows beyond 200 lines or mixes topics, split it and update this table.
