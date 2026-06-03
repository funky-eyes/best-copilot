# State Persistence Reference

Use this reference when task, verification, spec, memory, or evolution state must survive a new conversation.

## Principle

Spec is the authority for requirements, design, task acceptance, and task status. Memory is the recovery entry: current focus, next action, last verified evidence, durable decisions, and links. Chat history is not durable state.

## Required Files

For MEDIUM/LARGE active work, keep these files synchronized:

- `spec/<feature>/tasks.md`
- `spec/INDEX.md`
- `memories/repo/current-workstreams.md`
- `memories/repo/INDEX.md`
- one linked topic memory only when durable decisions or recovery notes exceed the active workstream entry

If the target repository lacks `spec/**` or `memories/repo/**`, run `target-spec-bootstrap` and `target-memory-bootstrap` before persistent work. If the files cannot be created or written, return `BLOCKED state_sync_unavailable`.

## Task Status Values

Use the shared handback vocabulary:

- `READY`
- `IN_PROGRESS`
- `DONE`
- `DONE_WITH_CONCERNS`
- `NEEDS_CONTEXT`
- `NEEDS_USER_INPUT`
- `BLOCKED`

Use `verification_result`: `passed | failed | blocked | not_run`.
Use `verification_coverage`: `complete | partial | blocked | not_applicable`.

## `tasks.md` Writeback

Every executable `tasks.md` must have either a top-level `## Progress Ledger` or per-task status blocks. If neither exists, add `## Progress Ledger` near the top, after metadata and cross-references when present.

Recommended ledger:

```markdown
## Progress Ledger

| Task ID | Status | Owner | Reviewer | Last updated | Verification | Evidence | Next action | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| T-001 | READY | Developer | Technical Architect | unknown | not_run | none | Start task | none |
```

Update one row whenever a task is picked, completed, blocked, reviewed, or verified. `DONE` requires review and verification evidence. `DONE_WITH_CONCERNS` must name the residual risk and whether it blocks downstream tasks.

If an existing `tasks.md` has only task definitions, create the ledger by scanning task IDs and initializing unknown rows. Do not rewrite task definitions just to add status.

## `current-workstreams.md` Writeback

Active workstreams should be compact and resumable:

```markdown
## Active Topics

### <topic>

- topic: `<slug>`
- status: `active | blocked | ready_for_review | closed`
- linked_spec: `spec/<feature>/tasks.md`
- linked_memory: `<none | memories/repo/<topic>.md>`
- current_focus: `<task id and short purpose>`
- completed_tasks: `<IDs or none>`
- blocked_tasks: `<IDs or none>`
- next_resume_action: `<single concrete next action>`
- last_verified: `<YYYY-MM-DD command/check/evidence>`
- last_state_sync: `<YYYY-MM-DD>`
- owner_lane: `<PM or specialist lane>`
- residual_risk: `<none | concise risk>`
```

When work closes, move the topic to `## Closed Topics` with final verification evidence and next maintenance note. If durable decisions were learned, compress them into `decisions.md` or a topic memory and update `memories/repo/INDEX.md`.

## `spec/INDEX.md` Writeback

Each active Spec Bundle row should point at the directory and linked memory:

```markdown
| Directory | Tags | Last updated | Status | Linked memory | Summary |
| --- | --- | --- | --- | --- | --- |
| `spec/<feature>/` | feature, active | <YYYY-MM-DD> | active | `memories/repo/current-workstreams.md` | <one-line summary> |
```

Status values: `draft | reviewed | approved | active | blocked | implemented | closed`.

## Memory Index Writeback

Whenever `current-workstreams.md`, `decisions.md`, `project-state.md`, or a topic memory changes, update `memories/repo/INDEX.md` `Last updated` and summary fields. Do not add raw logs, long transcripts, secrets, tokens, PII, or unverified guesses.

## Evolution Events

Accepted or rejected workflow evolution must leave an auditable record:

```markdown
## EvolutionEvent: <YYYY-MM-DD-topic>
- signal:
- target:
- mutation:
- validation:
- rollback:
- status: proposed|accepted|rejected|deprecated
```

Target-repository evolution belongs in target `memories/repo/**`, target `spec/**`, or target instructions. Plugin evolution belongs in this plugin checkout's root `agents/`, root `skills/`, `.github/instructions/**`, and associated references. Never store target project state in the plugin package or plugin cache.

## Resume Algorithm

1. Read `memories/repo/INDEX.md`.
2. Read `memories/repo/current-workstreams.md`.
3. Open the linked `tasks.md` and locate `Progress Ledger`.
4. Resume the first `IN_PROGRESS`, `BLOCKED` repair, or next `READY` task whose dependencies are satisfied.
5. Read only linked requirement/design/task shards and changed files needed for that task.

If ledger and memory disagree, trust command evidence and current files first, then repair both records before continuing.
