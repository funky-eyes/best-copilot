---
name: target-spec-bootstrap
description: "Create the target repository's local spec skeleton and reusable requirements/design/tasks templates. Use from repo-init-scan during first substantial plugin use, or from spec-writing flows when `spec/INDEX.md` or `spec/templates` is missing. Do not overwrite active project specs."
---

# Target Spec Bootstrap

Use this skill to create the target repository's spec routing structure. Specs are target-local delivery artifacts; this skill carries the installable templates.

## Boundary

- Write into the target repository, never into the installed plugin package or plugin cache.
- Create missing files only. Do not overwrite active specs or project-specific templates.
- Use specs for MEDIUM/LARGE requirements, design, tasks, acceptance checks, and ADRs.
- Link active specs to `memories/repo/current-workstreams.md` when persistent recovery is needed.

## Files

Create these paths when absent:

- `spec/INDEX.md`
- `spec/templates/requirements-template.md`
- `spec/templates/design-template.md`
- `spec/templates/tasks-template.md`

## `spec/INDEX.md`

```markdown
# Spec Index

<!-- markdownlint-disable MD013 -->

| Directory | Tags | Last updated | Status | Linked memory | Summary |
| --- | --- | --- | --- | --- | --- |
| `spec/templates/` | template, requirements, design, tasks | unknown | template | `memories/repo/workflow-rules.md` | Reusable templates for new spec bundles |

## Maintenance Rules

- Every MEDIUM/LARGE feature gets a spec directory with `requirements.md`, `design.md`, and `tasks.md`.
- Add a row here when creating a spec.
- Link active specs back to `memories/repo/current-workstreams.md`.
- Mark specs `closed` when the workstream is complete and memory has been compressed.
- Do not store secrets, raw private logs, or broad chat transcripts in specs.
```

## `spec/templates/requirements-template.md`

```markdown
# Requirements

## Background

`<fill: why this work exists>`

## Goals

- `<fill>`

## Non-goals

- `<fill>`

## Functional Requirements

- `<fill>`

## Constraints

- `<fill>`

## Acceptance Criteria

- `<fill: concrete checks>`

## Linked Memory

- `memories/repo/current-workstreams.md`
- `<fill: task memory file>`
```

## `spec/templates/design-template.md`

```markdown
# Design

## Overview

`<fill: design summary>`

## Current System Evidence

- `<fill: repo files or command evidence>`

## Proposed Changes

- `<fill>`

## Alternatives Considered

- `<fill>`

## Risks

- `<fill>`

## Verification Plan

- `<fill: commands, static checks, browser checks, or review checks>`

## Memory Update Plan

- Update `memories/repo/current-workstreams.md` with current focus and next action.
- Update the linked task memory with verified decisions only.
```

## `spec/templates/tasks-template.md`

```markdown
# Tasks

- [ ] 1. Freeze scope and fill linked memory.
  - Files: `<fill>`
  - Acceptance: `memories/repo/current-workstreams.md` points to this spec and linked memory.

- [ ] 2. Implement the smallest complete change.
  - Files: `<fill>`
  - Acceptance: `<fill>`

- [ ] 3. Verify and close.
  - Commands/checks: `<fill>`
  - Acceptance: verification evidence is recorded and memory is compressed.
```

## Verification

- Confirm `spec/INDEX.md` and missing templates exist in the target repository.
- Confirm existing active specs were preserved.
- Confirm new task specs, when created later, are linked from both `spec/INDEX.md` and `memories/repo/current-workstreams.md`.
