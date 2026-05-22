---
name: writing-plans
description: "Use when a MEDIUM/LARGE task needs concrete implementation tasks with files, dependencies, acceptance checks, and verification. DO NOT USE FOR: tiny single-file changes or unresolved design direction."
---

# Writing Plans

Use this skill to turn a confirmed direction or spec into executable work.

## Plan Shape

Each task must include:

- `goal`
- `files_involved`
- `dependencies`
- `parallel_ready`
- `context_mode`
- `context_budget`
- `ready_artifacts`
- `stop_conditions`
- `implementation_steps`
- `acceptance_checks`
- `verification_command`
- `non_goals`

## Decomposition Rules

- Tasks should be independently understandable in 2-5 minutes.
- Split by file ownership and dependency order, not by vague phases.
- Mark parallel only when write sets do not overlap.
- Give each task a small `ready_artifacts` list so fan-in can check outputs without rereading the whole conversation.
- Include `stop_conditions` for tasks that might otherwise expand into broad discovery.
- Public API, data model, auth, dependency, CI, or runtime config changes require blast radius notes.
- Avoid placeholders such as TODO, TBD, “add proper validation”, or “similar to previous task”.

## Closeout Gate

- Before ending the turn after presenting a plan, invoke `verification-before-completion`.
- If the next step requires user choice between execution paths or whether to continue, use native structured ask UI when available instead of a prose-only summary or `1/2/3` reply request. In VS Code, if `vscode_askQuestions` appears in the latest tool inventory, call that exact tool first; in Copilot CLI, use `Asking user` when available.

## Output

```markdown
# Implementation Plan: <topic>

## Overview
- total_tasks:
- sequential_dependencies:
- parallel_batches:
- verification_plan:

## Tasks
### Task 1: ...
```
