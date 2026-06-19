# Target Memory Bootstrap Templates

Use these neutral templates only for missing target-local memory files.

## `memories/README.md`

```markdown
# Repository Memory

This directory stores target-local AI memory for this repository.

Memory helps future sessions resume verified work without rereading every file. It does not override current repository files, command output, system instructions, or explicit user instructions.

## Layout

- `repo/INDEX.md`: routing table.
- `repo/current-workstreams.md`: active work and next resume action.
- `repo/project-state.md`: compact current state and constraints.
- `repo/workflow-rules.md`: memory/spec coordination rules and the self-evolution loop.
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
| `workflow-rules.md` | task-reference | workflow, prompt, memory, spec, evolution | Memory retrieval, prompt assembly, spec-memory coordination, and bounded evolution rules | `spec/INDEX.md` | unknown | Memory workflow and evolution rules |
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

## Workstream Entry Format

- `### <topic>`
- `topic`: `<slug>`
- `status`: `active | blocked | ready_for_review | closed`
- `linked_spec`: `spec/<feature>/tasks.md`
- `linked_memory`: `<none | memories/repo/<topic>.md>`
- `current_focus`: `<task id and short purpose>`
- `completed_tasks`: `<IDs or none>`
- `blocked_tasks`: `<IDs or none>`
- `next_resume_action`: `<single concrete next action>`
- `last_verified`: `<YYYY-MM-DD command/check/evidence>`
- `last_state_sync`: `<YYYY-MM-DD>`
- `owner_lane`: `<PM or specialist lane>`
- `evolution_signal`: `<none | accepted | rejected | deferred | proposed>`
- `residual_risk`: `<none | concise risk>`
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
tags: [workflow, memory, prompt, spec, token-budget, evolution]
---

# Workflow Rules

## One-line Summary

Use Markdown-based memory routing, stable-prefix prompt assembly, and the seven-module self-evolution loop to keep context small while preserving current progress and reusable learning.

## Current State

- Memory is split into active state, task reference, and archive/logs.
- `INDEX.md` routes by tags, use_for, load_tier, and linked_spec.
- `current-workstreams.md` stores current focus, next action, last verified evidence, and links to spec/memory.
- Memory retrieval follows progressive disclosure: index first, current state second, exact shard only when needed.
- Self-evolution follows seven separated responsibilities: Planner freezes scope, Executor performs the approved action, Observer records evidence, Evaluator judges quality and risk, Reflector extracts verified lessons, Memory stores only durable learning, and Policy updates bounded workflow rules.

## Constraints

- Memory never overrides current repo files, command output, system instructions, or explicit user instructions.
- Spec remains the authoritative source for requirements, design, task status, and acceptance.
- Memory stores status, decisions, recovery hints, and verified learnings only.
- Exclude secrets, tokens, private logs, and PII from durable memory.
- Evolution writeback requires evidence, validation, rollback, and an accepted/rejected/deferred status. Do not store raw chat or speculative prompt ideas as policy.
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
