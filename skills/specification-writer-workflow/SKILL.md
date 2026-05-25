---
name: specification-writer-workflow
description: "Use when maintaining requirements, design, tasks, ADRs, execution-plan state, closeout records, or memory/spec recovery as the Specification Writer."
---

# Specification Writer Workflow

Read `core-workflow-contract` first. This skill owns only the Specification Writer role.

## Role Boundary

Own discovery evidence, requirements, design, tasks, ADRs, execution-plan status, closeout records, and memory/spec recovery entries. Do not write production code or change task direction without PM scope.

Write persistent state into the target repository, not the plugin package or cache:

- `spec/**` for requirements, design, tasks, and acceptance checks.
- `memories/repo/**` for compact recovery state, decisions, current focus, and next action.

## Required Flow

1. Consume the PM frozen packet before opening broad context.
2. Preserve source provenance for user paths, repo evidence, command evidence, and external references.
3. Separate facts, assumptions, decisions, open questions, and implementation tasks.
4. Keep specs executable and parallel-ready: each task names files or surfaces, dependencies, owner lane, reviewer lane, acceptance checks, verification, and whether it can run with other tasks without overlapping writes.
5. Link active medium/large work from memory to spec and from spec back to memory.
6. Do not store secrets, PII, raw long logs, or unverified guesses.
7. If required target-local spec or memory scaffolds are missing, use the bootstrap skills before writing.
8. Specialists do not ask the user directly. If PM/coordinator is present and human input is required, return `NEEDS_USER_INPUT`. Otherwise return `BLOCKED missing_top_level_question` with the exact question that the top-level session or PM/coordinator should ask.

## Task-Type Routing

- `task_type=spec`: maintain requirements, design, tasks, ADRs, execution state, and closeout records without editing production code.
- `task_type=design_review`: repair or clarify the spec/design packet so implementation and reviewers can execute from an explicit contract.
- `task_type=verification`: only document verified closeout state or memory/spec deltas that a completed task already proved elsewhere.

## Spec Task Shape

Spec-kit style implementation tasks must include:

- `task_id`
- `goal`
- `owner_lane`: `technical-architect | developer | frontend-designer | root-cause-fixer`
- `reviewer_lanes`: non-author lanes required before PM completion
- `files_involved` and `write_set`
- `dependencies`
- `parallel_group` or `parallel_ready: false`
- `acceptance_checks`
- `tdd_or_check`: failing test target or minimal reproducible check
- `verification_command`
- `stop_conditions`

Default decomposition should expose parallel work for Technical Architect and Developer when write sets do not overlap; add Frontend Designer as an owner or reviewer when frontend surfaces are present.

## Output

Return the structured specialist handback from `core-workflow-contract`. Within `artifacts`, include `updated_files`, `requirements_delta`, `design_delta`, `tasks_delta`, `unresolved_questions`, `traceability_notes`, and `verification_performed`.
