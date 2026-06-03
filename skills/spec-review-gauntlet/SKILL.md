---
name: spec-review-gauntlet
description: "Use before implementation to review a Spec Bundle, design direction, or execution plan for readiness, traceability, scope discipline, multi-lane design risks, and TDD/verification feasibility. DO NOT USE FOR: implemented-code review or small already-frozen edits."
user-invocable: false
---

# Spec Review Gauntlet

Use this skill as the pre-implementation gate for MEDIUM/LARGE work and for high-risk customization workflow changes. It prevents a plan from entering implementation before requirements, design, task boundaries, and review ownership are ready.

## Spec Bundle Gate

For MEDIUM/LARGE target-repository implementation, the approved input must be a Spec Bundle directory containing `requirements.md`, `design.md`, and `tasks.md`.

- A single `spec/designs/*.md`, `spec/plans/*.md`, SDD note, or chat-only implementation plan is not an approved Spec Bundle.
- If the only available artifact is a single-file SDD/design/plan, return `readiness tier: not_ready`, classify the finding as `spec_blocker`, and recommend `revise_spec` so Specification Writer splits it into the three required files.
- For small bounded work, a compact approved plan can still be reviewed, but do not label it as a Spec Bundle.
- When shell access is available, run `target-spec-bootstrap/scripts/validate-spec-bundle.sh <target-root>/spec/<feature-slug>` before returning `ready` for MEDIUM/LARGE work.
- `tasks.md` must contain `## Progress Ledger` or equivalent per-task status blocks before implementation. If absent, return `readiness tier: not_ready` with `spec_blocker` so Specification Writer repairs it.

## Inputs

Read only the minimum necessary evidence:

- user-provided paths, current editor file, attachments, and priority files
- current Spec Bundle directory containing `requirements.md`, `design.md`, and `tasks.md`; for small bounded work only, an equivalent approved plan
- relevant owner files and already-read context supplied by PM
- changed files, search hints, and reference files when supplied

Do not expand to broad repository search unless a specific missing evidence category is identified.

## Readiness Checks

Check these dimensions before implementation:

- `completeness`: main path, edge cases, rollback/cleanup, and closeout are covered.
- `correctness`: requirements, design, tasks, defaults, and non-goals agree.
- `placeholder_scan`: no `TBD`, `TODO`, template residue, or unresolved choice remains.
- `scope_discipline`: file boundaries, non-goals, and forbidden approaches are explicit.
- `existing_code_leverage`: the plan reuses existing modules, helpers, tests, and ownership boundaries.
- `traceability`: each requirement maps to implementation tasks, tests/checks, and review lanes.
- `spec_density`: each section contains evidence, decision, constraint, risk, verification, or task routing; remove filler that does not affect implementation.
- `requirement_quality`: requirements have stable IDs, priority, source, acceptance signal, and one verifiable behavior per item.
- `design_quality`: design has decision IDs, ownership boundaries, API/data/config contracts, error behavior, compatibility, migration/rollback, and alternatives.
- `task_traceability`: each task references requirement/design IDs and includes owner lane, reviewer lanes, write set, dependencies, read-before-write targets, acceptance checks, verification, ready artifacts, and stop conditions.
- `progress_recovery`: `tasks.md` has durable task status fields, and active work links to `memories/repo/current-workstreams.md`.
- `tdd_testability`: new behavior or bug fixes can be proven with a failing test or minimal reproducible check.
- `task_granularity`: tasks are small enough to execute and review independently.
- `blast_radius`: public APIs, message formats, schemas, auth, dependencies, and release surfaces have explicit risk handling.
- `handoff_readiness`: each task includes complete text, `files_involved`, dependencies, acceptance checks, verification budget, and context hints.

For customization files, also check trigger surface, frontmatter/schema risk, tool availability, context bloat, route conflicts, and closeout/confirmation semantics.

Reject specs that only contain phase names, broad bullet lists, or implementation wishes without source evidence and observable acceptance checks.

## Multi-Lane Design Review

When the change touches cross-module behavior, public contracts, permissions, dependencies, data, frontend experience, or workflow routing, PM should run parallel design review lanes before implementation:

- Technical Architect: architecture feasibility and integration risk.
- Developer: implementation complexity, hidden coupling, and task granularity.
- Quality Assurance Expert: requirement completeness, testability, and regression risk.
- Security Reviewer: permissions, sensitive data, dependency, auth, and release-surface risk.
- Frontend Designer: add only when pages, components, interaction, responsive behavior, or browser experience are affected.

Reviewers challenge the design; they do not implement during design review.

## Finding Classification

Every concern should be classified before adjudication:

- `spec_blocker`: requirement, boundary, default, or traceability is missing or contradictory.
- `clarification_needed`: a user or product decision is required.
- `implementation_todo`: design is sound, but implementation must handle a specific detail.
- `risk_note`: non-blocking risk that should be tracked through verification.

Only `spec_blocker` and `clarification_needed` keep the work out of implementation. `implementation_todo` and `risk_note` move forward with explicit tracking.

## Output

Return:

- readiness tier: `ready | ready_with_concerns | not_ready`
- blocking findings and non-blocking concerns
- required spec/plan edits, if any
- implementation gates satisfied or missing
- traceability gaps by requirement/task ID
- recommended next stage: `implementation | revise_spec | clarify | split_scope`
