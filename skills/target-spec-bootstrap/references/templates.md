# Target Spec Bootstrap Templates

Use these neutral templates only for missing target-local spec files.

## `spec/INDEX.md`

```markdown
# Spec Index

<!-- markdownlint-disable MD013 -->

| Directory | Tags | Last updated | Status | Linked memory | Summary |
| --- | --- | --- | --- | --- | --- |
| `spec/templates/` | template, requirements, design, tasks | unknown | template | `memories/repo/workflow-rules.md` | Reusable templates for new spec bundles |

## Maintenance Rules

- Every MEDIUM/LARGE feature gets a spec directory with `requirements.md`, `design.md`, and `tasks.md`.
- Single-file SDD or plan notes under `spec/designs/` or `spec/plans/` are evidence only; they are not approved Spec Bundles.
- Add a row here when creating a spec.
- Link active specs back to `memories/repo/current-workstreams.md`.
- Mark specs `active`, `blocked`, `implemented`, or `closed` as work progresses.
- Mark specs `closed` only after the workstream is complete and memory has been compressed.
- Do not store secrets, raw private logs, or broad chat transcripts in specs.
```

## `spec/templates/requirements-template.md`

```markdown
# Requirements

## Metadata

- Status: `draft | reviewed | approved | closed`
- Owner lane: `senior-project-expert | specification-writer | technical-architect | developer | frontend-designer`
- Linked design: `design.md`
- Linked tasks: `tasks.md`
- Linked memory: `memories/repo/current-workstreams.md`, `<topic memory>`
- Last updated: `<YYYY-MM-DD>`

## Background

- Current behavior: `<what the system does now, with source references>`
- Trigger: `<user request, incident, roadmap item, audit finding, or repeated workflow failure>`
- Affected users or systems: `<actors, clients, jobs, APIs, or runtime surfaces>`
- Why now: `<risk, deadline, compatibility need, or quality gap>`

## Current System Evidence

| Evidence | Source | Why it matters | Confidence |
| --- | --- | --- | --- |
| `<fact>` | `<file, command, spec, or user source>` | `<impact on requirements>` | `high | medium | low` |

## Goals

- `<user-visible or operational outcome>`

## Non-Goals

- `<explicitly excluded behavior, migration, UI, API, dependency, or refactor>`

## Functional Requirements

| ID | Requirement | Priority | Source | Acceptance Signal | Task Refs |
| --- | --- | --- | --- | --- | --- |
| FR-001 | `<The system must ...>` | `P0 | P1 | P2` | `<evidence or user source>` | `<test, command, response, UI state, or static check>` | `<fill after tasks.md>` |

## Data, API, Security, And Compatibility

- Public API or route changes: `<none | endpoint, method, request, response, status codes>`
- Data model or schema changes: `<none | tables, columns, indexes, defaults, rollback>`
- Configuration and environment: `<none | keys, defaults, override rules>`
- Authentication and authorization: `<none | required behavior>`
- Sensitive data and logging: `<none | redaction, storage, retention>`
- Backward compatibility: `<what must remain unchanged>`
- Migration and rollback: `<none | forward and rollback plan>`

## Assumptions And Open Questions

| Type | Item | Impact if wrong | Resolution owner |
| --- | --- | --- | --- |
| Assumption | `<assumption>` | `<risk>` | `<lane/person>` |
| Open question | `<question>` | `<why it blocks or does not block>` | `<PM/user/lane>` |

## Acceptance Criteria

- `<AC-001: concrete observable check mapped to FR IDs>`

## Traceability Matrix

| Requirement | Design Section | Task | Verification |
| --- | --- | --- | --- |
| FR-001 | `<design.md#section>` | `<Task ID>` | `<test/command/check>` |

## Linked Memory

- `memories/repo/current-workstreams.md`
- `<topic memory file>`
```

## `spec/templates/design-template.md`

```markdown
# Design

## Metadata

- Status: `draft | reviewed | approved | implemented | closed`
- Requirement source: `requirements.md`
- Task source: `tasks.md`
- Owner lane: `technical-architect | frontend-designer | developer | specification-writer`
- Review lanes: `<developer, qa, security, frontend, technical-architect>`
- Last updated: `<YYYY-MM-DD>`

## Overview

- Problem summary: `<one or two sentences>`
- Chosen approach: `<smallest design that satisfies the requirements>`
- Compatibility stance: `<unchanged behavior, migration, or breaking-change note>`
- Rollout stance: `<direct, staged, feature flag, or manual migration>`

## Current System Evidence

| Surface | Source | Current behavior | Design implication |
| --- | --- | --- | --- |
| `<module/API/table/config>` | `<file, symbol, command, or spec>` | `<observed fact>` | `<constraint or reuse point>` |

## Design Decisions

| ID | Decision | Rationale | Requirement refs | Alternatives rejected |
| --- | --- | --- | --- | --- |
| DD-001 | `<decision>` | `<why this is the simplest safe option>` | `<FR IDs>` | `<summary>` |

## Proposed Changes

| Surface | Change | Owner lane | Read-before-write targets |
| --- | --- | --- | --- |
| `<file/module/API>` | `<add/change/remove>` | `<lane>` | `<public surface, caller/callee, shared utility>` |

## API, Data, Configuration, And Flow

- API routes or methods: `<none | request, response, status/error behavior>`
- Data model: `<none | tables, fields, indexes, defaults, migration, rollback>`
- Configuration: `<none | key, default, override, secret-handling>`
- External services or dependencies: `<none | dependency, version, failure mode>`
- Runtime flow: `<actor/request/event> -> <component> -> <state change or response> -> <verification point>`

## Error Handling And Risk

| Case | Expected behavior | Requirement refs | Verification |
| --- | --- | --- | --- |
| `<invalid input, missing config, stale data, auth failure, race, retry>` | `<response/state/log>` | `<FR IDs>` | `<test/check>` |

## Alternatives Considered

| Option | Why not chosen | Tradeoff kept |
| --- | --- | --- |
| `<alternative>` | `<specific reason>` | `<residual tradeoff>` |

## Verification Plan

| Requirement | Test or check | Command or method | Owner lane |
| --- | --- | --- | --- |
| `<FR ID>` | `<unit/integration/static/browser/manual>` | `<command or evidence>` | `<lane>` |

## Traceability

| Requirement | Design decision | Task | Verification |
| --- | --- | --- | --- |
| `<FR ID>` | `<DD ID>` | `<Task ID>` | `<check>` |

## Memory Update Plan

- Update `memories/repo/current-workstreams.md` with current focus, next action, and last verified evidence.
- Update linked topic memory only for durable decisions or recovery notes.
- Do not store raw logs, secrets, PII, or speculative guesses.
```

## `spec/templates/tasks-template.md`

```markdown
# Tasks

## Metadata

- Status: `draft | approved | active | blocked | implemented | closed`
- Requirement source: `requirements.md`
- Design source: `design.md`
- Linked memory: `memories/repo/current-workstreams.md`
- Last updated: `<YYYY-MM-DD>`

## Execution Rules

- Every implementation task must map to at least one requirement ID and one design decision.
- Split by ownership boundary, dependency order, and non-overlapping write set.
- Each task must include owner lane, reviewer lanes, write set, dependencies, parallel group/readiness, read-before-write targets, acceptance checks, verification, ready artifacts, and stop conditions.
- Keep tasks small enough for a fresh-context specialist to understand in 2-5 minutes; split mixed owner lanes or unrelated write sets before implementation.
- If a task has unresolved product or security input that changes behavior, mark it blocked instead of guessing.
- After each task status or verification change, update this `Progress Ledger` and `memories/repo/current-workstreams.md` before continuing.

## Progress Ledger

| Task ID | Status | Owner | Reviewer | Last updated | Verification | Evidence | Next action | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| T-001 | READY | `<lane>` | `<lane>` | unknown | not_run | none | Start task | none |

Status values: `READY | IN_PROGRESS | DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | NEEDS_USER_INPUT | BLOCKED`.
Verification values: `passed | failed | blocked | not_run | not_applicable`.

## Task List

### T-001: `<short imperative title>`

- Requirement refs: `<FR-001, FR-002>`
- Design refs: `<DD-001>`
- Owner lane: `technical-architect | developer | frontend-designer | root-cause-fixer | specification-writer`
- Reviewer lanes: `<developer, technical-architect, qa, security, frontend>`
- Files involved: `<explicit files or surfaces>`
- Write set: `<files this task may edit>`
- Read-before-write targets: `<public surface, immediate caller/callee, shared utility or local pattern>`
- Dependencies: `<none | Task IDs>`
- Parallel group: `<G0/G1/...>`
- Parallel ready: `<true | false with reason>`
- Acceptance checks:
  - `<observable result mapped to requirement refs>`
- TDD or minimal check:
  - `<failing test target, reproduction, static check, browser check, or N/A with reason>`
- Verification command:
  - `<command or manual evidence path>`
- Ready artifacts:
  - `<changed files, test evidence, review notes, migration note, memory update>`
- Stop conditions:
  - `<failed verification, missing context, write-set conflict, scope expansion, security concern>`

## Traceability Matrix

| Requirement | Design decision | Task | Acceptance | Verification |
| --- | --- | --- | --- | --- |
| `<FR ID>` | `<DD ID>` | `<Task ID>` | `<check>` | `<command/evidence>` |

## Closeout Checklist

- Requirements, design, tasks, and memory links agree.
- `Progress Ledger` has no `IN_PROGRESS`, `NEEDS_CONTEXT`, `NEEDS_USER_INPUT`, or `BLOCKED` rows unless explicitly closing with concerns.
- All required reviewer lanes are named and review evidence is linked.
- Verification commands are concrete and scoped.
- `memories/repo/current-workstreams.md` has final current focus, last verified evidence, and next resume action.
- Residual risks and skipped checks are explicit.
```
