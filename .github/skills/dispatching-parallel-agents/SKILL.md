---
name: dispatching-parallel-agents
description: "Use when multiple frozen subtasks have non-overlapping write sets and can be implemented or reviewed in parallel."
---

# Dispatching Parallel Agents

## Preconditions

- Each subtask has goal, files, dependencies, acceptance checks, and verification.
- Write sets do not overlap.
- Shared foundation work is already done or assigned as a dependency.
- Fan-in owner is identified.

## Fan-out Packet

Include:

- `sub_task_id`
- `goal`
- `files_involved`
- `must_do`
- `must_not_do`
- `verification`
- `handoff_contract`

## Fan-in

Merge results by dependency order. Re-run integration verification after combining parallel work.
