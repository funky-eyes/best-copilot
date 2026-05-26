---
name: writing-plans
description: "Use when a MEDIUM/LARGE task needs concrete implementation tasks with files, dependencies, acceptance checks, and verification. DO NOT USE FOR: tiny single-file changes or unresolved design direction."
---

# Writing Plans

Use this skill to turn a confirmed direction or spec into executable work.

## Plan Shape

Each task maps to the six-block PM dispatch packet from `core-workflow-contract` plus plan-specific fields:

- **task_intent**: `goal`
- **frozen_scope**: `non_goals`, `files_involved`, `write_set`, `dependencies`, `owner_lane`, `reviewer_lanes`, `parallel_group`, `parallel_ready`
- **execution_contract**: `acceptance_checks`, `tdd_or_check`, `verification_command`, `stop_conditions`, `context_budget`
- **output_contract**: `ready_artifacts`, `implementation_steps`

## Decomposition Rules

- Tasks should be independently understandable in 2-5 minutes.
- Plan SDD first, then TDD: each task consumes reviewed design context and includes either a failing test target or a minimal reproducible check before implementation.
- Split by file ownership, dependency order, and review lane, not by vague phases.
- Mark parallel only when write sets do not overlap.
- Prefer parallel groups that let Technical Architect and Developer work independently; add Frontend Designer as owner or reviewer for frontend surfaces.
- Assign cross-review lanes per the Cross-Review Lanes from `core-workflow-contract`.
- Give each task a small `ready_artifacts` list so fan-in can check outputs without rereading the whole conversation.
- Include `stop_conditions` for tasks that might otherwise expand into broad discovery.
- Public API, data model, auth, dependency, CI, or runtime config changes require blast radius notes.
- Avoid placeholders such as TODO, TBD, “add proper validation”, or “similar to previous task”.

## Closeout Gate

- Before ending the turn after presenting a plan, invoke `verification-before-completion`.
- If the next step requires user choice between execution paths or whether to continue, follow the Native Ask Contract from `core-workflow-contract` for structured ask UI requirements.

## Output

```markdown
# Implementation Plan: <topic>

## Overview
- total_tasks:
- sequential_dependencies:
- parallel_batches:
- owner_lanes:
- reviewer_lanes:
- verification_plan:

## Tasks
### Task 1: ...
```
