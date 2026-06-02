---
name: target-spec-bootstrap
description: "Create the target repository's local spec skeleton and reusable requirements/design/tasks templates. Use from repo-init-scan during first substantial plugin use, or from spec-writing flows when `spec/INDEX.md` or `spec/templates` is missing. Do not overwrite active project specs."
---

# Target Spec Bootstrap

Use this skill to create the target repository's spec routing structure. Specs are target-local delivery artifacts; this skill carries the installable templates.

## Boundary

- Write into the target repository, never into the installed plugin package or plugin cache.
- Create missing files only. Do not overwrite active specs or project-specific templates.
- Do not copy this plugin repository's active specs, memory, or workflow examples into the target repository. Generate only neutral target-local templates.
- Use specs for MEDIUM/LARGE requirements, design, tasks, acceptance checks, and ADRs.
- A MEDIUM/LARGE feature spec is a **Spec Bundle directory**, not a single markdown file. The required files are `requirements.md`, `design.md`, and `tasks.md` in the same feature directory, for example `spec/oidc-upgrade/requirements.md`, `spec/oidc-upgrade/design.md`, and `spec/oidc-upgrade/tasks.md`.
- `spec/designs/*.md`, `spec/plans/*.md`, or any other single-file SDD/plan artifact may be used only as transient evidence. They do not satisfy the Spec Bundle gate and must be split into the three template-backed files before implementation planning or execution.
- Generated templates must be detailed enough to execute from: evidence, requirements, design decisions, task ownership, verification, and traceability are first-class sections.
- Keep templates dense, not verbose. Every section should ask for facts, decisions, checks, or links that change implementation behavior.
- Link active specs to `memories/repo/current-workstreams.md` when persistent recovery is needed.

## Files

Create these paths when absent:

- `spec/INDEX.md`
- `spec/templates/requirements-template.md`
- `spec/templates/design-template.md`
- `spec/templates/tasks-template.md`

## Spec Bundle Guard

Use the bundled validator when shell access is available and a MEDIUM/LARGE feature is about to leave spec/design review:

```bash
<best-copilot-skills-dir>/target-spec-bootstrap/scripts/validate-spec-bundle.sh <target-root>/spec/<feature-slug>
```

The validator is intentionally shallow: it checks the required three files and their basic source links. It is not a substitute for content review, but it prevents single-file SDD documents from being mistaken for an executable Spec Bundle.

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
- Mark specs `closed` when the workstream is complete and memory has been compressed.
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

Describe the problem in observable terms, not as a desired implementation.

- Current behavior: `<what the system does now, with source references>`
- Trigger: `<user request, incident, roadmap item, audit finding, or repeated workflow failure>`
- Affected users or systems: `<actors, clients, jobs, APIs, or runtime surfaces>`
- Why now: `<risk, deadline, compatibility need, or quality gap>`

## Current System Evidence

| Evidence | Source | Why it matters | Confidence |
| --- | --- | --- | --- |
| `<fact>` | `<file, command, spec, or user source>` | `<impact on requirements>` | `high | medium | low` |

Record unknowns explicitly. Do not turn guesses into requirements.

## Goals

- `<user-visible or operational outcome>`

## Non-Goals

- `<explicitly excluded behavior, migration, UI, API, dependency, or refactor>`

## Functional Requirements

Use one verifiable behavior per row. Prefer `must` statements with observable input, output, state change, or failure mode.

| ID | Requirement | Priority | Source | Acceptance Signal | Task Refs |
| --- | --- | --- | --- | --- | --- |
| FR-001 | `<The system must ...>` | `P0 | P1 | P2` | `<evidence or user source>` | `<test, command, response, UI state, or static check>` | `<fill after tasks.md>` |

## Data, API, and Contract Requirements

- Public API or route changes: `<none | endpoint, method, request, response, status codes>`
- Data model or schema changes: `<none | tables, columns, indexes, defaults, rollback>`
- Message or file formats: `<none | format, producer, consumer, compatibility>`
- Configuration and environment: `<none | keys, defaults, override rules>`

## Security, Privacy, and Compliance Requirements

- Authentication and authorization: `<none | required behavior>`
- Sensitive data and logging: `<none | redaction, storage, retention>`
- Dependency or supply-chain risk: `<none | new dependency and rationale>`
- Abuse cases or invalid input: `<required rejection behavior>`

## Compatibility and Migration Requirements

- Backward compatibility: `<what must remain unchanged>`
- Rollout or feature flag: `<none | staged behavior>`
- Migration and rollback: `<none | forward and rollback plan>`
- Existing data or clients: `<impact and mitigation>`

## Assumptions and Open Questions

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

### Component and Ownership Map

| Surface | Change | Owner lane | Read-before-write targets |
| --- | --- | --- | --- |
| `<file/module/API>` | `<add/change/remove>` | `<lane>` | `<public surface, caller/callee, shared utility>` |

### API, Data, and Configuration Contracts

- API routes or methods: `<none | request, response, status/error behavior>`
- Data model: `<none | tables, fields, indexes, defaults, migration, rollback>`
- Configuration: `<none | key, default, override, secret-handling>`
- External services or dependencies: `<none | dependency, version, failure mode>`

### Runtime Flow

- Flow: `<actor/request/event> -> <component> -> <state change or response> -> <verification point>`

### Error Handling and Edge Cases

| Case | Expected behavior | Requirement refs | Verification |
| --- | --- | --- | --- |
| `<invalid input, missing config, stale data, auth failure, race, retry>` | `<response/state/log>` | `<FR IDs>` | `<test/check>` |

### Security, Privacy, and Release Risk

- Auth and permission boundary: `<none | required checks>`
- Sensitive data handling: `<none | redaction/encryption/storage>`
- Public contract or schema blast radius: `<none | affected clients and mitigation>`
- Rollback and cleanup: `<none | exact rollback path>`

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
- Update the linked topic memory with durable decisions only.
- Do not store raw logs, secrets, PII, or speculative guesses.
```

## `spec/templates/tasks-template.md`

```markdown
# Tasks

## Execution Rules

- Every implementation task must map to at least one requirement ID and one design decision.
- Split by ownership boundary, dependency order, and non-overlapping write set; do not split by vague phases alone.
- Each task must include read-before-write targets, acceptance checks, verification, reviewer lanes, and stop conditions.
- If a task has unresolved product or security input that changes behavior, mark it blocked instead of guessing.

## Task List

### Task 1: `<short imperative title>`

- Requirement refs: `<FR-001, FR-002>`
- Design refs: `<DD-001>`
- Owner lane: `technical-architect | developer | frontend-designer | root-cause-fixer | specification-writer`
- Reviewer lanes: `<developer, technical-architect, qa, security, frontend>`
- Files involved: `<explicit files or surfaces>`
- Write set: `<files this task may edit>`
- Read-before-write targets: `<public surface, immediate caller/callee, shared utility or local pattern>`
- Dependencies: `<none | Task IDs>`
- Parallel group: `<G0/G1/... or parallel_ready: false>`
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
- All required reviewer lanes are named.
- Verification commands are concrete and scoped.
- Residual risks and skipped checks are explicit.
```

## Verification

- Confirm `spec/INDEX.md` and missing templates exist in the target repository.
- Confirm existing active specs were preserved.
- Confirm new task specs, when created later, are linked from both `spec/INDEX.md` and `memories/repo/current-workstreams.md`.
- Confirm generated templates contain metadata, evidence, traceability, verification, and task ownership sections.
- If this skill was invoked because `spec/**` was missing and the required files still do not exist after the attempt, return `BLOCKED target_spec_bootstrap_incomplete` with the missing paths. Do not let the caller continue the substantive task as if initialization succeeded.
