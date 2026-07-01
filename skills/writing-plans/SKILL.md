---
name: writing-plans
description: "Use when a MEDIUM/LARGE task needs concrete implementation tasks with files, dependencies, acceptance checks, and verification. DO NOT USE FOR: tiny single-file changes or unresolved design direction."
---

# Writing Plans

Use this skill to turn a confirmed direction or spec into executable work.

## Boundary

- For MEDIUM/LARGE target-repository work, implementation planning consumes a Spec Bundle directory with `requirements.md`, `design.md`, and `tasks.md`.
- A standalone `# Implementation Plan: <topic>` is a transient planning view only. It may be used in chat or as review evidence, but it must not replace `spec/<feature>/tasks.md` and must not be recorded as the active spec in `spec/INDEX.md`.
- If a confirmed direction exists only as a single SDD/design/plan file, stop and route to Specification Writer to split it into the three-file Spec Bundle before implementation execution.
- Before implementation starts, verify `tasks.md` exists, maps each task to requirement/design IDs, and includes a `## Progress Ledger` or equivalent per-task status blocks. When shell access is available, run the Spec Bundle validator from `target-spec-bootstrap`.

## Plan Shape

Each task maps to the six-block PM dispatch packet from `core-workflow-contract` plus plan-specific fields:

- **task_intent**: `goal`
- **frozen_scope**: `requirement_refs`, `design_refs`, `non_goals`, `files_involved`, `write_set`, `dependencies`, `owner_lane`, `reviewer_lanes`, `parallel_group`, `parallel_ready`
- **execution_contract**: `assumptions`, `tradeoffs`, `simpler_option_considered`, `acceptance_checks`, `tdd_or_check`, `verification_command`, `stop_conditions`, `context_budget`, `review_package_strategy`, `reviewer_input_boundary`, `model_policy`, `model_cost_boundary`, `final_independent_review`, `read_before_write_targets`
- **output_contract**: `ready_artifacts`, `implementation_steps`
- **state_sync**: required `tasks.md` progress ledger/status update, `current-workstreams.md` update, and index updates when rows change

## Decomposition Rules

- Tasks should be independently understandable in 2-5 minutes.
- Every task should cite the requirement IDs and design decision IDs it satisfies; if it cannot, repair the spec before planning implementation.
- Prefer success criteria, constraints, and verification over micro-prescribed implementation steps. Include concrete steps only when dependency order, safety, or verification makes them necessary.
- Plan SDD first, then TDD: each task consumes reviewed design context and includes either a failing test target or a minimal reproducible check before implementation.
- Split by file ownership, dependency order, and review lane, not by vague phases.
- Mark parallel only when write sets do not overlap.
- Prefer parallel groups that let Technical Architect and Developer work independently; add Frontend Designer as owner or reviewer for frontend surfaces.
- Assign cross-review lanes per the Cross-Review Lanes from `core-workflow-contract`.
- Give each task a small `ready_artifacts` list so fan-in can check outputs without rereading the whole conversation.
- Keep each task independently understandable, but avoid embedding whole specs, diffs, logs, or broad chat summaries; use file-backed refs and recovery pointers for large evidence.
- Include a `Progress Ledger` in persistent `tasks.md`; task status and verification changes must be durable before the next task starts.
- Include material assumptions, meaningful tradeoffs, and the simplest viable option for each task or batch; if an unresolved question changes implementation or acceptance, mark it as a blocker instead of planning from a guess.
- Include `read_before_write_targets` for code-editing tasks: target file public surface/exports, immediate caller/callee, and obvious shared utility or local pattern to inspect.
- Include `review_package_strategy` for review-required work: how changed files, diff, task brief, acceptance checks, and context shards will be referenced without pasting the same large material into every reviewer prompt.
- Include `reviewer_input_boundary`: allowed evidence and forbidden controller/author severity, merge, or approval framing.
- Include explicit `model_policy` and `model_cost_boundary` for batch subagent work when the runtime supports model selection; otherwise record the runtime-default limitation.
- For standard/full batches, include `final_independent_review` with scope, reviewer lane, required evidence, and closeout criteria.
- Include `stop_conditions` for tasks that might otherwise expand into broad discovery.
- Include `ready_artifacts` that fan-in can check directly: changed files, tests/checks run, review notes, migration notes, and memory/spec updates when relevant.
- Public API, data model, auth, dependency, CI, or runtime config changes require blast radius notes.
- Avoid placeholders such as TODO, TBD, “add proper validation”, or “similar to previous task”.

## Closeout Gate

- Before ending the turn after presenting a plan, invoke `verification-before-completion`.
- If the next step requires user choice between execution paths or whether to continue, follow the Native Ask Contract from `core-workflow-contract` for structured ask UI requirements.

## Output

Use this output for a transient planning summary or for the content of `spec/<feature>/tasks.md`. For MEDIUM/LARGE persistent specs, the final artifact must be `tasks.md` inside the Spec Bundle.

```markdown
# Implementation Plan: <topic>

## Overview
- total_tasks:
- sequential_dependencies:
- parallel_batches:
- owner_lanes:
- reviewer_lanes:
- verification_plan:

## Progress Ledger

| Task ID | Status | Owner | Reviewer | Last updated | Verification | Evidence | Next action | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |

## Tasks
### Task 1: ...
```
