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
- `implementation_steps`
- `acceptance_checks`
- `verification_command`
- `non_goals`

## Decomposition Rules

- Tasks should be independently understandable in 2-5 minutes.
- Split by file ownership and dependency order, not by vague phases.
- Mark parallel only when write sets do not overlap.
- Public API, data model, auth, dependency, CI, or runtime config changes require blast radius notes.
- Avoid placeholders such as TODO, TBD, “add proper validation”, or “similar to previous task”.

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
