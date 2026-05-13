---
name: target-memory-bootstrap
description: "Create the target repository's local memory skeleton after repo init. Use from repo-init-scan during first substantial plugin use, when `memories/repo` is missing, or when MEDIUM/LARGE work needs persistent recovery state. Do not store active project memory in the plugin package."
---

# Target Memory Bootstrap

Use this skill to create durable, target-local memory routing files. The generated memory starts empty and project-neutral; later tasks fill it with verified target repository facts.

## Boundary

- Write into the target repository, never into the installed plugin package or plugin cache.
- Create missing files only. Do not overwrite existing target memory.
- Do not copy this plugin repository's current work, decisions, or examples as active target memory.
- Memory is for recovery state, verified decisions, and compact facts. It is not for long logs, secrets, or raw chat transcripts.

## Files

Create these paths when absent:

- `memories/README.md`
- `memories/repo/INDEX.md`
- `memories/repo/current-workstreams.md`
- `memories/repo/project-state.md`
- `memories/repo/workflow-rules.md`
- `memories/repo/decisions.md`
- `memories/repo/logs/README.md`
- `memories/repo/archive/deprecated-decisions.md`

## `memories/README.md`

```markdown
# Repository Memory

This directory stores target-local AI memory for this repository.

Memory helps future sessions resume verified work without rereading every file. It does not override current repository files, command output, system instructions, or explicit user instructions.

## Layout

- `repo/INDEX.md`: routing table.
- `repo/current-workstreams.md`: active work and next resume action.
- `repo/project-state.md`: compact current state and constraints.
- `repo/workflow-rules.md`: memory/spec coordination rules.
- `repo/decisions.md`: durable dated decisions.
- `repo/logs/`: compressed logs loaded only on demand.
- `repo/archive/`: deprecated or historical memory.
```

## `memories/repo/INDEX.md`

```markdown
# Repo Memory Index

<!-- markdownlint-disable MD013 -->

## Retrieval Order

1. Read this index.
2. If resuming active work, read `current-workstreams.md`.
3. Follow `linked_spec` and `linked_memory`.
4. Load only the relevant section from the selected memory file.
5. Fall back to archive/logs only when source tracing is required.

## Routing Table

| File | Load tier | Tags | Use for | Linked spec | Last updated | One-line summary |
| --- | --- | --- | --- | --- | --- | --- |
| `current-workstreams.md` | task-active | resume, progress, active-spec | Resume current work and find next action | `spec/INDEX.md` | unknown | Active workstream summary |
| `project-state.md` | task-reference | project, status, constraints | Current project state and important constraints | `spec/INDEX.md` | unknown | Compact project state |
| `workflow-rules.md` | task-reference | workflow, prompt, memory, spec | Memory retrieval, prompt assembly, and spec-memory coordination rules | `spec/INDEX.md` | unknown | Memory workflow rules |
| `decisions.md` | task-reference | decisions, deprecated | Durable decisions and superseded decisions | `spec/INDEX.md` | unknown | Date-stamped decisions |
| `logs/README.md` | archive-reference | logs, recovery | Compressed logs loaded only on demand | none | unknown | Archive area for compressed logs |
| `archive/deprecated-decisions.md` | archive-reference | archive, deprecated | Historical decisions that should not guide new work by default | none | unknown | Deprecated decisions and replacement links |

## Maintenance Rules

- Every new repo memory file must get one routing row here.
- Update `last_updated` and the one-line summary when a memory file changes.
- Do not paste long logs into this index.
- If a file grows beyond 200 lines or mixes topics, split it and update this table.
```

## `memories/repo/current-workstreams.md`

```markdown
---
id: current-workstreams
type: active-state
updated_at: unknown
status: initialized
load_tier: task-active
tags: [resume, progress, active-spec]
---

# Current Workstreams

## Routing

- Load when: resuming work, checking current progress, or deciding next action.
- Pair with: `spec/INDEX.md`, the selected `linked_spec`, and the selected `linked_memory`.
- Skip when: the task is a one-off question unrelated to active project state.

## Active Topics

- None yet.

## Closed Topics

- None yet.
```

## `memories/repo/project-state.md`

```markdown
---
id: project-state
type: project-memory
updated_at: unknown
status: initialized
priority: medium
tags: [project, state, constraints]
---

# Project State

## One-line Summary

unknown

## Current State

- Current focus: unknown
- Key acceptance signals: unknown
- Current risk: unknown

## Constraints

- Memory stores recovery state and verified decisions, not long logs or secrets.

## Open Questions

- None recorded.
```

## `memories/repo/workflow-rules.md`

```markdown
---
id: workflow-rules
type: repo-memory
updated_at: unknown
status: initialized
priority: high
tags: [workflow, memory, prompt, spec, token-budget]
---

# Workflow Rules

## One-line Summary

Use Markdown-based memory routing and stable-prefix prompt assembly to keep context small while preserving current progress.

## Current State

- Memory is split into active state, task reference, and archive/logs.
- `INDEX.md` routes by tags, use_for, load_tier, and linked_spec.
- `current-workstreams.md` stores current focus, next resume action, last verified evidence, and links to spec/memory.
- Memory retrieval follows progressive disclosure: index first, current state second, exact shard only when needed.

## Constraints

- Memory never overrides current repo files, command output, system instructions, or explicit user instructions.
- Spec remains the authoritative source for requirements, design, and task acceptance.
- Memory stores status, decisions, recovery hints, and verified learnings only.
- Exclude secrets, tokens, private logs, and PII from durable memory.
```

## `memories/repo/decisions.md`

```markdown
---
id: decisions
type: decision-memory
updated_at: unknown
status: initialized
tags: [decisions, deprecated]
---

# Decisions

## Active Decisions

- None yet.

## Deprecated Decisions

- None yet.

## Decision Update Rule

When a decision changes, add a new dated entry and mark the old entry deprecated with the replacement decision.
```

## `memories/repo/logs/README.md`

```markdown
# Memory Logs

Store compressed, task-specific logs only when they are needed for future recovery.

- Prefer summaries and command evidence over raw logs.
- Do not store secrets, tokens, private data, or full chat transcripts.
- Link important log summaries from `memories/repo/INDEX.md` when they become retrieval-worthy.
```

## `memories/repo/archive/deprecated-decisions.md`

```markdown
# Deprecated Decisions

Historical decisions live here only after they have been replaced or should no longer guide new work by default.

## Entries

- None yet.
```

## Verification

- Confirm all missing files were created in the target repository.
- Confirm existing target memory files were preserved.
- Confirm placeholders are neutral (`unknown` or `None yet`) and do not describe the plugin repository as the target project.
