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

Each parallel subtask uses the six-block PM dispatch packet from `core-workflow-contract`. At minimum include:

- `task_intent`: `goal`, `task_type`, `work_mode`
- `frozen_scope`: `files_involved`, `write_set`, `dependencies`
- `execution_contract`: `constraints`, `acceptance_checks`, `verification_budget`, `forbidden_approaches`
- `output_contract`: required skills, `required_artifacts`

Add `sub_task_id` for fan-in tracking.

## Fan-in

Adjudicate fan-in using the priority order from `core-workflow-contract` Fan-In Arbitration. Accept only structured handbacks with the required fields. Merge results by dependency order. Re-run integration verification after combining parallel work.
