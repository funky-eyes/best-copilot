---
name: context-packet-fastpath
description: "Use to prepare a minimal context packet for a delegated subtask or to consume a frozen packet without re-reading unrelated files."
---

# Context Packet Fastpath

Uses the six-block PM dispatch packet from `core-workflow-contract`. This skill lists all fields grouped by block for quick reference.

## Packet Fields (by block)

### 1. task_intent

`goal`, `user_provided_paths`, `user_intent_summary`, `expected_outcome`, `task_type` (`implementation | design_review | verification | fix | spec`), `work_mode` (`micro | standard | full`)

### 2. frozen_scope

`scope`, `non_goals`, `files_involved`, `changed_files`, `priority_files`, `already_read_files`, `dependencies`, `owner_lane`, `reviewer_lanes`, `write_set`, `parallel_group`

### 3. fact_packet

`authoritative_repo_facts`, `source_provenance_refs`, `reference_files`

### 4. execution_contract

`constraints`, `acceptance_checks`, `verification_budget`, `search_hints`, `context_budget` (max files/shards before returning for scope widening), `stop_conditions`, `forbidden_approaches`

### 5. review_state

`review_followup_scope`, `previously_verified_items`, `review_lanes`, `ready_artifacts` (files, commands, screenshots, review outputs already produced)

### 6. output_contract

`required_artifacts`, `recommended_next_stage`, `dispatch_reason`, `retrieval_provenance`, `memory_refs`, `spec_refs`

## Rules

- Lean packet: enough for one small task.
- Full packet: needed only for cross-module or high-risk work.
- Prefer `micro` or `standard` packets when the file set and acceptance checks are already clear.
- Do not include whole logs, whole specs, or unrelated memory.
- Include only the retrieval provenance needed to justify selected files.
- If a delegate needs new files, return to PM to widen scope.
- A delegate must consume `task_type`, `user_intent_summary`, `review_followup_scope`, `previously_verified_items`, `ready_artifacts`, `required_artifacts`, and `recommended_next_stage` before reopening search.
- A delegate should stop at `context_budget` and return `NEEDS_CONTEXT` instead of broad-scanning.
- A delegate should treat `authoritative_repo_facts` and `source_provenance_refs` as fixed context unless the packet says they are provisional.
- Follow the Specialist Ask Boundary from `core-workflow-contract`.
