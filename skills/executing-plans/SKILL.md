---
name: executing-plans
description: "Use when executing an already approved multi-step implementation plan or tasks.md with checkpoints, verification evidence, and per-task review. Requires current execution confirmation when the packet is part of PM orchestration. DO NOT USE FOR: brainstorming, spec writing, or one tiny isolated edit."
user-invocable: false
---

# Executing Plans

Use this skill to turn an approved plan into a checkpointed execution loop. The goal is not to run through every task as fast as possible; the goal is to make each task independently auditable, resumable, and verified.

## Preconditions

- If the input packet is part of a PM orchestration flow, `execution_confirmed` must be present and must match the current `plan_revision`.
- The plan must list concrete tasks, dependencies, `files_involved`, assumptions or explicit unknowns, acceptance checks, and verification commands or checks.
- The plan must not contain placeholders such as `TBD`, `TODO`, or `to be decided`.
- User-provided paths, current editor files, attachments, and priority files must be consumed before broad search.

If any precondition fails, return `NEEDS_CONTEXT`, `NEEDS_USER_INPUT`, or `BLOCKED` instead of executing from guesses. Use `NEEDS_USER_INPUT` only when human input or approval is required; missing repository/task evidence is `NEEDS_CONTEXT`.

## Execution Loop

For each ready task, follow this exact order:

1. `PICK`: identify task id, target files, dependencies, success criteria, assumptions, tradeoffs, and the simplest viable approach.
2. `READ`: before code edits, inspect the target file's public surface/exports, the immediate caller or callee, and obvious shared utilities or local patterns.
3. `EXECUTE`: make the smallest diff inside the frozen file set. Do not add speculative features, single-use abstractions, or adjacent cleanup.
4. `VERIFY`: run the minimal sufficient command or static/browser check.
5. `REVIEW_STAGE_1`: check spec/task compliance first. Confirm that the task did exactly the requested work, no more and no less.
6. `REVIEW_STAGE_2`: check code quality, maintainability, release risk, dead code, and test adequacy.
7. `RECORD`: write task status, verification result, verification coverage, command/check evidence, and residual risk.
8. `SNAPSHOT`: update the ready-artifact list with changed files, verification command, review outputs, blocked items, next resume action, and a done/verified/left checkpoint summary.
9. `DECIDE`: proceed, fix, return to spec, or block with evidence.

Do not invert the two review stages. A task that fails spec compliance is not ready for code-quality signoff.

## Status Contract

- `task_status`: `DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | NEEDS_USER_INPUT | BLOCKED`
- `verification_result`: `passed | failed | blocked`
- `verification_coverage`: `complete | partial | blocked`
- `ready_artifacts`: changed files, verification evidence, review outputs, blocked items, next resume action
- Follow the Specialist Handback Schema from `core-workflow-contract`.
- If checkpoint records use `task_status`, map it to the shared `status` field before PM fan-in.

Never use a test result as the task status. Never claim `DONE` without real evidence.

## Parallel Batches

- Tasks may run in parallel only when dependencies are satisfied and write sets do not overlap.
- Default to at most three concurrent tasks unless the platform gives a smaller limit.
- Fan-in must summarize each task separately before any shared checkpoint decision.

## Verification

- Prefer targeted checks while individual tasks are in progress.
- Run a broader integration/build/test pass only after the relevant batch or plan slice is complete.
- If a command times out or the environment is unavailable, mark verification as `blocked`; do not treat the absence of evidence as success.

## Prohibitions

- Do not execute an unconfirmed PM plan.
- Do not leave placeholders in the plan or progress record.
- Do not modify files outside the current task boundary.
- Do not skip spec compliance review because tests pass.
- Do not close a task before both review stages and verification evidence are recorded.
- Do not continue from a checkpoint you cannot summarize as done, verified, and left.
